#!/bin/bash

# Install zephir
echo -e "----------------------------------------"
echo "VAGRANT ==> Zephir"
if [[ ! -d /srv/www/tools/zephir ]]; then
	echo "Cloning latest Zephir"
	cd /srv/www/tools/zephir
	git clone https://github.com/phalcon/zephir &> /dev/null
	cd zephir
else 
	echo "Zephir already cloned"
	echo "Pulling latest changes"
	cd /srv/www/tools/zephir
	git pull
fi
./install -c
chmod ugo+x /usr/local/bin/zephir

#
# Phalcpn PHP Framework 3
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Setup Phalcon Framework 3"
#sudo apt-add-repository ppa:phalcon/stable
#curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
#curl -s https://packagecloud.io/install/repositories/phalcon/nightly/script.deb.sh | sudo bash
#sudo apt-get install -y php7.0-phalcon
#echo 'extension=phalcon.so' > /etc/php/7.0/mods-available/phalcon.ini
#ln -s /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/fpm/conf.d/20-phalcon.ini
#ln -s /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/cli/conf.d/20-phalcon.ini

if [[ ! -d /srv/www/tools/cphalcon ]]; then
	echo "Cloning latest Phalcon"
	cd /srv/www/tools
	git clone https://github.com/phalcon/cphalcon &> /dev/null
	cd cphalcon
else	
	echo "Phalcon already cloned"
	echo "Pulling latest changes"
	cd /srv/www/tools/cphalcon
	git pull
fi
echo "Compiling Phalcon"
zephir build
echo "Generating latest IDE Stubs"
zephir stubs


# Install phalcon dev tool 
echo -e "----------------------------------------"
echo "VAGRANT ==> Phalcon dev tools"

if [[ ! -d /srv/www/tools/phalcon-devtools ]]; then
	echo "Cloning latest Phalcon devtools"
	cd /srv/www/tools
	git clone https://github.com/phalcon/phalcon-devtools.git &> /dev/null
	ln -s /srv/www/tools/phalcon-devtools/phalcon.php /usr/local/bin/phalcon
	chmod ugo+x /usr/local/bin/phalcon
else 
	echo "Phalcon devtools already cloned"
	echo "Pulling latest changes"
	cd /srv/www/tools/phalcon-devtools
	git pull
fi

# Install phalcon incubator
echo -e "----------------------------------------"
echo "VAGRANT ==> Phalcon incubator"

if [[ ! -d /srv/www/tools/incubator ]]; then
	echo "Cloning latest Phalcon incubator"
	cd /srv/www/tools
	git clone https://github.com/phalcon/incubator.git &> /dev/null
else 
	echo "Phalcon incubator already cloned"
	echo "Pulling latest changes"
	cd /srv/www/tools/incubator
	git pull
fi

#
# Reload servers
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Restart Nginx & PHP-FPM"
sudo service nginx restart
sudo service php7.0-fpm restart
