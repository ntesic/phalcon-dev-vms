# Ubuntu 16 Vagrant VM: Phalcon 3 + PHP 7
* Git
* Nginx
* PHP 7
* Phalcon 3
* MySQL 5.7
* Redis
* Composer
* NodeJS
* NPM
* PHPUnit

# Quick install
1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/)
3. Clone this project `git clone https://github.com/uonick/vagrant-php7-phalcon.git`
4. Go to directory with README file (`cd vagrant-php7-phalcon`)
5. Run `vagrant up`
6. Run on host machine:
    * Linux:
        * `sudo apt-get install dnsmasq`
        * `echo "address=/.dev/192.168.3.3" >> /etc/dnsmasq.conf`
    * macOS:
        * `brew install dnsmasq`
7. :tada: :balloon:

# Development
1. Go to `vagrant-php7-phalcon/www/`
2. Make `directory`
3. Open url `http://directory.dev/`
4. Enjoy :sunglasses:
"# phalcon-dev-vms" 
