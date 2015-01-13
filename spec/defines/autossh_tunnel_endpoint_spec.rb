require 'spec_helper'

describe 'autossh::tunnel_endpoint', :type => :definition  do

  let(:title) { 'somename' }
  let :params do
    {
      :enable => true,
      :user   => 'autossh',
      :port   => '25',
      :monitor_port => '2000',
      :host   => 'server1.foo.bar',
      :pubkey => 'ssh-dss IOUEOWDOQ...'
    }
  end

  context 'with defaults for all parameters' do
    #it { should contain_concat__fragment('autossh_autossh_authkey_server1.foo.bar_25') }
  end
end
