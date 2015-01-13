require 'spec_helper'

describe 'autossh', :type => :class  do

  let(:title) { 'init' }

  #
  # Test that an error is raised on unsupported systems
  #
  context 'On Unsupported OS' do
    let(:facts) {{ :osfamily => 'UNKNOWN' }}
  
    it { 
      expect { should raise_error(Puppet::Error) } 
    }
  end  


  #
  # test that an error IS raised on unsupported systems (RHEL7)
  #
  context 'On Unsupported RedHat based OS' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '4' }}
    
    it { 
      expect { should raise_error(Puppet::Error) } 
    }

  end

  #
  # test that an error IS NOT raised on supported systems (RHEL6)
  #
  context 'On RHEL6 based OS' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '6',
                   :concat_basedir => '/dne' }}
    
    it { 
      should contain_class('autossh')
    }

  end

  #
  # test that an error IS NOT raised on supported systems (RHEL6)
  #
  context 'On RHEL7 based OS' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '7',
                   :concat_basedir => '/dne' }}
    
    it { 
      should contain_class('autossh')
    }

  end

  #
  # test default values
  #
  context 'test default values' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '6',
                   :concat_basedir => '/dne' }}
    
    it { 
      should contain_class('autossh')
      should contain_class('autossh::install')
      should contain_class('autossh::params')
      should contain_user('autossh')
      should contain_package('autossh')
      should contain_package('openssh-clients')
      should contain_package('redhat-lsb-core')
      should contain_file('auto_ssh_conf_dir').with(
        :ensure =>  'directory',
        :path   => '/etc/autossh',
        :mode   => '0755',
        :owner  => 'root',
        :group  => 'root'

      ) 
    }

  end

  context 'test default values' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '7',
                   :concat_basedir => '/dne' }}
    
    it { 
      should contain_class('autossh')
      should contain_class('autossh::install')
      should contain_class('autossh::params')
      should contain_user('autossh')
      should contain_package('autossh')
      should contain_package('openssh-clients')
      should_not contain_package('redhat-lsb-core')
      should contain_file('auto_ssh_conf_dir').with(
        :ensure =>  'directory',
        :path   => '/etc/autossh',
        :mode   => '0755',
        :owner  => 'root',
        :group  => 'root'
      ) 
      should contain_file('autossh-tunnel.sh')
      should contain_Concat ("/home/autossh/.ssh/config")
      should contain_Concat__Fragment("home_autossh_ssh_config_global")
      should contain_Exec("concat_/home/autossh/.ssh/config")
      should contain_file("/dne/_home_autossh_.ssh_config/fragments.concat.out")
      should contain_file("/dne/_home_autossh_.ssh_config/fragments.concat")
      should contain_file("/dne/_home_autossh_.ssh_config/fragments/10_home_autossh_ssh_config_global")
      should contain_file("/dne/_home_autossh_.ssh_config/fragments")
      should contain_file("/dne/_home_autossh_.ssh_config")
      should contain_file("/dne/bin/concatfragments.sh")
      should contain_file("/dne/bin")
      should contain_file("/dne")
      should contain_Class("Concat::Setup")
      should contain_file("/home/autossh/.ssh/config")
      should contain_file("/home/autossh/.ssh")
      should contain_file("/var/tmp/autossh-1.4d-4.el7.centos.x86_64.rpm")
    }

  end

  context 'test ssh_config default parameters' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '7',
                   :concat_basedir => '/dne',
                    }}
    it { 
      should contain_Concat__Fragment("home_autossh_ssh_config_global").without({
        :content => /ControlMaster auto\n/m
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /Host */m,
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /Ciphers = blowfish-cbc,aes128-cbc,3des-cbc,cast128-cbc,arcfour,aes192-cbc,aes256-cbc\n/m,
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /Compression no\n/m,
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /StrictHostKeyChecking no\n/m,
      })
    }

  end

  context 'test ssh_config updated parameters' do
    let(:facts) {{ :osfamily => 'RedHat',
                   :operatingsystemmajrelease => '7',
                   :ssh_reuse_established_connections => true, 
                   :concat_basedir => '/dne',
                   :remote_ssh_host => "x.y.z.p",
                   :ssh_ciphers => "cipher chain",
                   :ssh_enable_compression => "true",
                   :ssh_stricthostkeychecking => "true", }}
    it { 
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /ControlMaster auto\n/m
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /Host */m,
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /Ciphers = blowfish-cbc,aes128-cbc,3des-cbc,cast128-cbc,arcfour,aes192-cbc,aes256-cbc\n/m,
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /Compression yes/m,
      })
      should contain_Concat__Fragment("home_autossh_ssh_config_global").with({
        :content => /StrictHostKeyChecking yes\n/m,
      })
    }

  end
end
