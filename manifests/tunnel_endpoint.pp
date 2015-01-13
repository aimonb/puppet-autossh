# == Class: autossh::tunnel_endpoint
#
# Defines an enpoint for an ssh tunnel, usually created on the 'target node'.
# This class is called from the 'tunnel' class and should not need to be 
# invoked directly.
#
# This class:
#   * creates a 'concat::fragment' for the target authorized_keys file.
# 
# === Parameters
#
# $enable = Enable/Disable this service.
# $user   = The target user account for this tunnel.
# $port   = The target port for this tunnel.
# $host   = The target host/ip for this tunnel.
# $pubkey = The public key to be used to authenticate this tunnel.
#
# === Variables
#
# === Examples
#
#  autossh::tunnel_endpoint  { 'testtunnel': 
#    enable => true,
#    user   => 'autossh',
#    port   => '25',
#    monitor_port = '2000',
#    host   => 'server1.foo.bar',
#    pubkey => 'ssh-dss IOUEOWDOQ...'
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
define autossh::tunnel_endpoint(
  $port,
  $host,
  $monitor_port = $autossh::params::monitor_port,
  $pubkey = $autossh::params::pubkey,
  $enable = $autossh::params::enable,
  $user   = $autossh::params::user,
)
{
  concat::fragment{"${::hostname}_autossh_${user}_authkey_${host}_${port}":
    target  => "/home/${user}/.ssh/authorized_keys",
    content => template('autossh/endpoint.erb'),
    order   => 10,
    tag     => "authkey_fragment_${user}_${host}",
  }
}
