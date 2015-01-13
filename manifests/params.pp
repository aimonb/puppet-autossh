# == Class: autossh::params
#
# This class defines the default values used in the autossh class.
# 
# === Parameters
#
# === Variables
#
# $autossh_version: The install version for the autossh package
# $autossh_build: The build number for the autossh package
# $user: The user account to be used to run autossh processes.
# $enable: enable/disable package support.
# $autossh_package: The package to be installed for autossh support.
# $pubkey: default pubkey.. not all that useful really.
# $tunnel_type: default tunnel type
# $remote_ssh_port: default remote ssh port number
# $monitor_port: 0 default monitoring port number for autossh
# $ssh_reuse_established_connections: default enable reuse of already 
#              established ssh connections, if any.  Requires ssh > 5.5.
# $ssh_compression: enable/disable ssh compression 
# $ssh_ciphers: cipher selection ordering.  (fastest -> slowest)
# $ssh_stricthostkeychecking: enable/disable strict host key checking
# $ssh_tcpkeepalives: enable/disable tcp keepalives
#
# === Examples
#
#  class { autossh:
#  }
#
# === Authors
#
# Jason Ball <jason@ball.net>
#
# === Copyright
#
# Copyright 2014 Jason Ball.
#
class autossh::params {
  $autossh_version = '1.4d'
  $autossh_build    = 4
  $user             = 'autossh'
  $enable           = true
  $pubkey           = ''
  $tunnel_type      = 'forward'
  $remote_ssh_port  = '22'
  $monitor_port     = '0'
  $ssh_reuse_established_connections = false  ## Requires openssh > v5.5
  $ssh_enable_compression = false ## Not really useful for local connections 
  $ssh_ciphers =
    'blowfish-cbc,aes128-cbc,3des-cbc,cast128-cbc,arcfour,aes192-cbc,aes256-cbc'
  $ssh_stricthostkeychecking = false
  $ssh_tcpkeepalives = true


  case $::osfamily {
    /RedHat/: {
      case $::operatingsystemmajrelease {
        /5|6/: {
          $autossh_package =
            "autossh-${autossh_version}-${autossh_build}.el6.x86_64.rpm"
          $init_template = 'autossh.init.sysv.erb'
        }
        /7/: {
          $autossh_package =
            "autossh-${autossh_version}-${autossh_build}.el7.centos.x86_64.rpm"
          $init_template = 'autossh.init.systemd.erb'
        }
        default: {
          fail("Error - Unsupported OS Version: ${::operatingsystemrelease}")
        }
      } # $::operatingsystemmajrelease  
    } # RedHat

    /Debian/: {
          $autossh_package = 'autossh'
          $init_template = 'autossh.init.systemd.erb'
    }

    default: {
      fail("Unsupported Operating System: ${::osfamily}")
    }
  } # $::osfamily
}
