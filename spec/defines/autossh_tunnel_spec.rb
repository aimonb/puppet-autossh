require 'spec_helper'

describe 'autossh::tunnel', :type => :definition  do

  let(:title) { 'somename' }

  let :params do
    {
      :user             => 'someuser',
      :tunnel_type      => 'reverse',
      :port             => '22',
      :hostport         => '2000',
      :remote_ssh_host  => '123.123.123.1',
      :remote_ssh_port  => '22',
      :monitor_port     => '0',
      :enable           => 'true',
      :pubkey           => 'ssh-dss UNKNOWN',
    }
  end

  context 'with defaults for all parameters' do
    let(:facts) {{ :osfamily => 'RedHat',
                 :operatingsystemmajrelease => 6 }}

    it { should contain_file('autossh-somename-init').with(
      :ensure  => 'present',
      :path    => "/etc/init.d/autossh-somename",
      :mode    => '0750',
      :owner   => 'root',
      :group   => 'root',
    ) }
    it { should contain_file('autossh-somename_conf').with(
      :ensure  => 'present',
      :path    => "/etc/autossh/autossh-somename.conf",
      :mode    => '0660',
      :owner   => 'someuser',
      :group   => 'someuser',
    ) }
    it { should contain_service('autossh-somename').with(
      :ensure =>  'true',
      :enable =>  'true'
    ) }
    it { should contain_class('Autossh::Tunnel[somename]') }
  end

  context 'testing systemd init' do
    let(:facts) {{ :osfamily => 'RedHat',
                 :operatingsystemmajrelease => 7 }}
    it { should_not contain_file('autossh-somename-init')
    }
    it { should contain_file('autossh-somename_conf').with(
      :ensure  => 'present',
      :path    => "/etc/autossh/autossh-somename.conf",
      :mode    => '0660',
      :owner   => 'someuser',
      :group   => 'someuser',
    ) }
    it { should contain_file('systemd-service-somename').with(
      :ensure  => 'present',
      :path    => "/etc/systemd/system/autossh-somename.service",
      :mode    => '0750',
      :owner   => 'root',
      :group   => 'root',
    ) }
    it { should contain_service('autossh-somename').with(
      :ensure =>  'true',
      :enable =>  'true'
    ) }
    it { should contain_class('Autossh::Tunnel[somename]') }
  end
end
