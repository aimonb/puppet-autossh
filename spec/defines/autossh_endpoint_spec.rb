require 'spec_helper'

describe 'autossh::endpoint', :type => :definition  do

  let(:title) { 'somename' }
  let :params do
    {
      :user   => 'autossh',
      :host   => 'server1.foo.bar',
    }
  end

  context 'with defaults for all parameters' do
    #it { should contain_class('autossh::endpoint') }
    #it { should contain_concat('/home/autossh/.ssh/authorized_keys') }
  end
end
