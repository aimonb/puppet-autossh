# == Class: autossh
#
# The autossh service configures persistent 'ssh port forwards' or 'ssh tunnels'
# between two nodes.  This class caters for both sides of the link from the 
# 'origin' node which starts the ssh tunnel to the 'endpoint' node which 
# terminates that tunnel.  There is a base assumption that both nodes connect 
# to the same puppetdb.
#
# === Parameters
#
# $user            = The user account to be used to run the ssh sessions.
# $autossh_version = The autossh package version
# $autossh_build   = The autossh package build number
# $autossh_package = The autossh package name
# $init_template   = Template to use for the init script
# $enable          = Enable/Disable package support
# $pubkey          = Public key to use for tunnels.  If supplied at this level 
#                    is used as the default for all tunnels.
# $enable          = enable/disable the tunnel
# $ssh_reuse_established_connections  =  $enable_ssh_reuse: default enable 
#                   reuse of already established ssh connections, if any. 
#                   Requires openssh > 5.5.
# $ssh_enable_compression = enable/disable compression
# $ssh_ciphers      = set chiper path from lest to most expensive
# $ssh_stricthostkeychecking = enable/disable strict host key checking
# $ssh_tcpkeepalives: enable/disable tcp keepalives
#
#
# === Variables
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
class autossh(
  $user            = $autossh::params::user,
  $autossh_version = $autossh::params::autossh_version,
  $autossh_build   = $autossh::params::autossh_build,
  $autossh_package = $autossh::params::autossh_package,
  $init_template   = $autossh::params::init_template,
  $enable          = $autossh::params::enable,
  $ssh_reuse_established_connections =
    $autossh::params::ssh_reuse_established_connections,
  $ssh_enable_compression = $autossh::params::ssh_enable_compression,
  $ssh_ciphers = $autossh::params::ssh_ciphers,
  $ssh_stricthostkeychecking = $autossh::params::ssh_stricthostkeychecking,
  $ssh_tcpkeepalives = $autossh::params::ssh_tcpkeepalives,
) inherits autossh::params {
  include ::autossh::install
}
