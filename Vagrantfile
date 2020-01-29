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
   config.vm.provision "shell", inline: <<-SHELL
     # Installation block
     yum -y install epel-release
     yum -y install vim cockpit bash-completion postfix dovecot telnet nc
     yum -y install cyrus-sasl cyrus-sasl-plain
     yum -y install pdns pdns-recursor
     yum -y install bind-utils
     # OS configuration block
     hostnamectl set-hostname allinone-mh.localhost
     
     #Service configuration block
     systemctl enable --now cockpit.socket
     systemctl enable --now saslauthd.service

     # User configuration block
     useradd engineer 
     usermod -p '$6$xyz$.UccqMWqX8VK4PRzmKTR1woU2y5IgDas9n.XPkhgK8M62yVqI4sLx.Yw2AC5z7t4Ke3NiU7aq7i3Su5QdrRcF1' engineer
     useradd manager
     usermod -p '$6$xyz$PcPt/h72LIQm.YoxBmDLqfpbX1w3vhcJ1LwyYjOaslRr67l0g3ZkE5nKN0c4Ed98wYTvMWvhlGcV7NZorCE2i/' manager
     useradd contractor
     usermod -p '$6$xyz$tlQI91A01E6TWfFL6jqBSSLdzLKJtFyF2aWfdTZyOBUn56UjQbMyecGla5IMGqX./neusxkBsr3IwUGZhTnel0' contractor
     
   SHELL
   config.vm.provision "shell", path: "configure_mail_server.sh"
   config.vm.provision "shell", inline: <<-SHELL
    chmod 0600 /var/mail/*
    systemctl enable --now postfix 
    systemctl enable --now dovecot
    systemctl enable --now pdns-recursor
    systemctl enable --now pdns
   SHELL
end
