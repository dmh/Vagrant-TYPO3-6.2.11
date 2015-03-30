# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]
    #config.vm.network "forwarded_port", guest: 80, host: 9030
    #config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    #config.vm.network "public_network", ip: "192.168.33.13"
    config.vm.network "private_network", ip: "192.168.33.11"
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.vm.provision :shell, path: "provision.sh"
end
