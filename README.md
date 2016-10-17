# phalcon-dev-vms
# Ubuntu 16 Vagrant VM: Phalcon 3 + PHP 7
* Git
* Nginx
* PHP 7
* Phalcon 3
* Phalcon Dev Tools
* MySQL 5.7
* Redis
* Composer
* NodeJS
* NPM
* PHPUnit
* Zephir
* Memcache
* Sphinx

# Quick install
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/)
3. Clone this project `git clone https://github.com/ntesic/phalcon-dev-vms.git`
4. Go to directory with README file (`cd phalcon-dev-vms`)
5. Run `vagrant up`
6. Optional: Run `vagrant provision --provision-with phalcon` to update to latest phalcon/zephir/devtools


# Development
1. Go to `/srv/www/`
2. Make `directory`
3. Open url `http://directory.dev/`
