##autossh

The autossh module facilitates the automated management of ssh based port forward between nodes.  The ssh tunnels are run via the 'autossh' wrapper 
which starts/monitors and restarts the tunnels if and when they close.   This service:

* Installs the required package support.
* Configures the 'autossh' configuration file.
* Creates a system initialsation script (init script).
* exports resources to automate the configuration of the 'remote' nodes.
* automatically configures remote nodes to provide a secure tunnel capability.

This module was initially based on the following module(s) from the puppet forge:

    aimonb/autosshdd

However this module has been rewritten to provide:

* Support for multiple tunnels on any given host.
* Support for Hiera integration
* Support for configuration of the 'tunnel endpoint'
* Secure configuration of the tunnel endpoint.
* Customistion of the important ssh configurations for the ssh tunnels.

As tested this module can support any number of ssh tunnels on any given host, and automatically syncronises the tunnel endpoints providing both nodes connect to the same puppetdb.

The 'autossh' service provides a reliability and monitoring capability for the ssh tunnels, this includes monitoring the link via a separate 'monitoring ports' if configured and automatically restarting the ssh session if it fails due to an abnormal termination or error detected on the monitoring port.   I'm gradually adding more functionality here to support customisation of the ssh parameters to watch this space as the module develops.

Management of the private key is left to you as care needs to be taken to ensure this private key is adequately protected.  I've encrypted the private key using eyaml and find this a convenient approach but that does depend on having hiera configured correctly.



##Classes

autossh
----

The 'autossh' class configures the autossh environment, installs the required package support, and configures the global ssh options to be applied to ssh sessions.

This class needs to be run on all nodes using autossh.

```
Class {'::autossh': 
}
```

#####`user`

The linux user account to be used to run the ssh sessions.  Ideally this should be a service account, defaults to `autossh`

#####`autossh_version`

The version of autossh to install.  Only applies when the packaged autossh rpm is installed on systems lacking autossh support.

#####`autossh_build`
 
The package build to install.  Only applies when the packaged autossh rpm is installed on systems lacking autossh support.

#####`autossh_package`

The autossh rpm package name.  Only apples when the packaged autossh rpm is installed on systems lacking autossh support.

#####`init_template`

The template to use for the system init script.  Shouldn't need to change this.

#####`enable`

Enable/Disable this package and service.  This functionality is gradually being added, not overly useful right now.

#####`ssh_reuse_established_connections`

Enables ssh connection reuse if an established connection already exists to the target host.  This can speed up the time it takes to make the connection, note that this is only supported on 'openssh' > 5.5

#####`ssh_enable_compression`

Enables/Disables ssh compression in the tunnel.   Connections over slow links may benefit from compression, local lan connections are probably better off without it.

#####`ssh_ciphers`

Sets the cipher ordering for the ssh sessions.   The default is from 'fastest' to 'slowest'.

#####`ssh_stricthostkeychecking`

By default host key checking is disabled to enable connections to proceed without error. Without this setting an admin would need to ensure the target server was in the known hosts file.

#####`ssh_tcpkeepalives`

Enable/Disable TCP Keepalives to prevent firewalls from closing the tunnel.

autossh::tunnel
----

Create a tunnel on the host including the necessary init scripts to start and stop the service.  Optionally ssh parameters can be customised on a per host basis.

```
  autossh::tunnel { 'port_25_tunnel_to_server1': 
    port             => '25',
    hostport         => '25',
    remote_ssh_host  => 'server1',
    pubkey           => 'ssh-dss <OMITTED>'
  } 
```

#####`user`

The linux user account to be used to run the ssh sessions.  Ideally this should be a service account, defaults to `autossh`

#####`tunnel_type`

The direction of the ssh tunnel.  'forward' for 'host --> target' and 'reverse' for 'target` --> 'host'

#####`port`

The local port to be used for the ssh tunnel

#####`hostport`

The remote port to be used for the ssh tunnel

#####`remote_ssh_host`

The remote host/ip to connect to for the tunnel.

#####`remote_ssh_port`

The remote port to connect to for the tunnel.

#####`monitor_port`

The port(s) to use for the autossh monitoring functionality.   2 ports are actually used, the base port and the base port + 1 (.i.e. 20000 and 20001).

#####`pubkey`

The public key to use for the authentication of this connection.

#####`enable`

Enable/Disable this package and service.  This functionality is gradually being added, not overly useful right now.

#####`enable_host_ssh_config`

Enable host specific ssh configurations.  This will override the global settings created in the autossh class.

#####`ssh_reuse_established_connections`

Enables ssh connection reuse if an established connection already exists to the target host.  This can speed up the time it takes to make the connection, note that this is only supported on 'openssh' > 5.5

#####`ssh_enable_compression`

Enables/Disables ssh compression in the tunnel.   Connections over slow links may benefit from compression, local lan connections are probably better off without it.

#####`ssh_ciphers`

Sets the cipher ordering for the ssh sessions.   The default is from 'fastest' to 'slowest'.

#####`ssh_stricthostkeychecking`

By default host key checking is disabled to enable connections to proceed without error. Without this setting an admin would need to ensure the target server was in the known hosts file.

#####`ssh_tcpkeepalives`

Enable/Disable TCP Keepalives to prevent firewalls from closing the tunnel.

autossh::endpoint
----

Configure the endpoint (target) for an ssh connection.   This class is run on the destination nodes for any ssh tunnels.

```

 autossh::endpoint  { 'createtunnels': 
   user   => 'autossh',
   host   => 'server1.foo.bar',
 }

```

#####`user`

The linux user account to be used to run the ssh sessions.  Ideally this should be a service account, defaults to 'autossh'

#####`host`

The hostname/ip address specified in the 'authssh::tunnel', this is used to filter the tunnel::enpoint exported resources.


##Examples 

Simple Example
------

The simple example creates a single ssh tunnel between two nodes, starting at the origin and terminating at the 'destination' using DSL only:

**Prepare Private/Public Keys**

Generate the necessary private and public keys for the ssh sessions.   The private key will need to be placed in the '.ssh' folder
for the run user (default: /home/autossh/.ssh/) and the public key used when configuring the service.

**Origin Node**

```
  class { '::autossh':
  }

  autossh::tunnel { 'port_25_tunnel_to_server1': 
    port             => '25',
    hostport         => '25',
    remote_ssh_host  => 'server1',
    pubkey           => 'ssh-dss <OMITTED>'
  } 
```

**Destination Node**

```
  class { '::autossh':
  }

  autossh::endpoint { 'load ssh endpoints': 
    host   => 'server1',
  }
```
     



Complex Example
------

The following example creates multiple ssh port forwards between two nodes, the Origin and Destination using DSL and Hiera.  This example also includes the installation of the private key which is stored using hiera-eyaml and default values to reduce the specific instance configuration.

**Role - Origin Node**

```
  $autossh_user = hiera('autossh::user')

  class { '::autossh': 
    user => $autossh_user
  }

  $autossh_key = hiera('autossh::privkey')
  file { "/home/${autossh_user}/.ssh/id_dsa":
    ensure => file,
    owner => $autossh_user,
    group => $autossh_user,
    mode => "0400",
    content => $autossh_key,
    replace => no,
  }

  $tunnels = hiera_hash('autossh::tunnels')
  $defaults = hiera_hash('autossh::defaults')
  create_resources('autossh::tunnel',$tunnels,$defaults)
}

```

**Profile - Origin Node**

```

autossh::tunnels:
  tunnel_pmaster:
    port: 8140
    hostport: 8140
    remote_ssh_host: 172.16.255.2
  tunnel_smtp:
    port: 25
    hostport: 1125
    remote_ssh_host: 172.16.255.2

autossh::user: 'autossh'
autossh::privkey: ENC[PKCS7, OMITTED]
autossh::defaults:
  pubkey: ssh-dss OMITTED
  tunnel_type: reverse
  user: autossh
  remote_ssh_port: 22
  monitor_port: 0
  enable: true

```


**Role - Destination Node**

```
class capability::autosshtarget {
  $autossh_user = hiera('autossh::user')

  class { '::autossh': 
    user => $autossh_user
  }

  $autossh_hostip = hiera('autossh::hostip')
  autossh::endpoint{'load autossh enpoint details':
    user => $autossh_user,
    host => $autossh_hostip,
  }
```

**Profile - Destination Node**

```

autossh::hostip: 172.16.255.2
autossh::user: 'autossh'
autossh::pubkey: 'ssh-dss OMITTED'

```
