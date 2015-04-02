# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    #Vagrant BOX / Official Ubuntu Server 14.04 LTS (Trusty Tahr) builds
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_check_update = false

    #Private Network / Static IP = 192.168.33.33
    config.vm.network "private_network", ip: "192.168.33.33"
    config.vm.synced_folder ".", "/var/www", type: "nfs"

    #Public network / commented
    #config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    #config.vm.network "public_network", bridge: 'en1: Wi-Fi (AirPort)'
    #config.vm.synced_folder ".", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

    #Omit some terminal errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    #Provision
    config.vm.provision :shell, path: "provision.sh"

    #Name of VM host
    config.vm.define "typo3-6.2.11" do |typo3|
    end

    #VM Performance
    config.vm.provider "virtualbox" do |v|
        host = RbConfig::CONFIG['host_os']
        # Give VM 1/2 system memory & access to all cpu cores on the host
        if host =~ /darwin/
            cpus = `sysctl -n hw.ncpu`.to_i
            mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 2
        elsif host =~ /linux/
            cpus = `nproc`.to_i
            mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 2
        else
            cpus = 2
            mem = 4096
        end
        v.customize ["modifyvm", :id, "--memory", mem]
        v.customize ["modifyvm", :id, "--cpus", cpus]
    end
end
