# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

    config.vm.box = "bento/ubuntu-16.04"
    config.vm.box_check_update = true
    config.vm.hostname = "phalcon-dev-vms"

    config.vm.network :forwarded_port, guest: 80, host: 1238
    config.vm.network :forwarded_port, guest: 3306, host: 3306
    config.vm.network :forwarded_port, guest: 6379, host: 6379

    config.vm.network "private_network", ip: "192.168.50.10"

    config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--vram", "32"]
		v.customize ["modifyvm", :id, "--memory", 8192]
		v.customize ["modifyvm", :id, "--cpus", 4]
    end
    	#config.ssh.private_key_path = "~/.ssh/id_rsa"
	config.ssh.password = "vagrant"
	config.ssh.insert_key = false

    config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
	config.vm.synced_folder "config/", "/srv/config"
    config.vm.provision 'main', type: 'shell', path: "./scripts/setup.sh"
	config.vm.provision 'phalcon' , type: 'shell', path: "./scripts/phalcon.sh"
end
