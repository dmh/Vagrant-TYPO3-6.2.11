#Vagrant TYPO3-6.2.11

###What is it?
Package to quick deploy blank **TYPO3** 6.2.11 on virtual machine.

**Vagrant** config + **Shell** Provisioner + **Bower** components

### Requirements

- VirtualBox <http://www.virtualbox.com>
- Vagrant <http://www.vagrantup.com>
- Git <http://git-scm.com/>
- Bower <http://bower.io/>

### Usage

```
git clone https://github.com/dmh/Vagrant-TYPO3-6.2.11.git
cd Vagrant-TYPO3-6.2.11
bower install
vagrant up
```

To stop Vagrant VM: `vagrant destroy`

Status:  `vagrant status`

Open SSH session: `vagrant ssh`

### Connecting

Apache server is available at http://192.168.33.33

Web root: `/var/www/public/`

MySQL

- Username: root
- Password: 1234
- DB name: typo3

TYPO3

- TYPO3 login: admin
- TYPO3 password: admin1234
- TYPO3 install tools password: admin1234


### Shell Provisioner. Installed Components.

- Ubuntu 14.04 64-bit (Trusty)
- Apache 2
- PHP 5.5
- MySQL 5.5
- git
- Imagemagick

##Important

Don't forget to change __ip__ address for your virtual machine, if you have several of them based on this package.
`config.vm.network "private_network", ip: "your new IP"`

Also you can change name of VM:

`config.vm.define "VM name" do |typo3|`
