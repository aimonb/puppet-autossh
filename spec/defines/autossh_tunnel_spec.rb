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
    }
  end

  context 'with defaults for all parameters' do
    it { should contain_file('auto_ssh_conf_dir').with(
      :ensure =>  'directory',
      :path   => '/etc/autossh',
      :mode   => '0755',
      :owner  => 'root',
      :group  => 'root'
    ) }
    it { should contain_file('autossh-somename_conf').with(
      :ensure  => 'present',
      :path    => "/etc/autossh/autossh-somename.conf",
      :mode    => '0660',
      :owner   => 'someuser',
      :group   => 'someuser',
    ) }
    it { should contain_file('autossh-somename-init').with(
      :ensure  => 'present',
      :path    => "/etc/init.d/autossh-somename",
      :mode    => '0750',
      :owner   => 'root',
      :group   => 'root',
    ) }
    it { should contain_service('autossh-somename').with(
      :ensure =>  'true',
      :enable =>  'true'
    ) }
  end
end
