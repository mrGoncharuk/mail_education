# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/centos-8"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  
  # For Cockpit
  config.vm.network "forwarded_port", guest: 9090, host: 19090, host_ip: "127.0.0.1"
  
  # For SMTP
  config.vm.network "forwarded_port", guest: 25, host: 1025
  
  # For IMAP
  config.vm.network "forwarded_port", guest: 143, host: 1143

  # For POP3
  config.vm.network "forwarded_port", guest: 110, host: 1110

  # For Apache
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # For submission
  config.vm.network "forwarded_port", guest: 587, host: 1587


  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.provider "virtualbox" do |v|  
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--memory", 4096]
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = trueconfig.vm.provision "shell", path: "configure_mail_server.sh", run: 'always'
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
#  Vagrant.configure("2") do |config|
#    config.vm.provision "puppet" do |puppet|
#      puppet.manifests_path = "manifests"
#      puppet.manifest_file = "default.pp"
#    end
#  end
  config.vm.provision "puppet install", type: "shell", inline: <<-SHELL
    dnf -y install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm
    yum -y install puppet
    yum -y install pdk
	/opt/puppetlabs/bin/puppet module install puppet-archive
	/opt/puppetlabs/bin/puppet module install puppet-posix_acl
	/opt/puppetlabs/bin/puppet module install puppetlabs-selinux_core
	/opt/puppetlabs/bin/puppet module install /vagrant/oleksandriegorov-mailplatform-0.1.0.tar.gz
	/opt/puppetlabs/bin/puppet apply /vagrant/default.pp
  SHELL
end
