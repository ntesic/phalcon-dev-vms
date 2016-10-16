#!/bin/bash
# Using Ubuntu

export COMPOSER_ALLOW_SUPERUSER=1

sudo echo "127.0.1.1 ubuntu-xenial" >> /etc/hosts
#
# Install
#
echo "============    BEGIN SETUP   ============="
echo -e "----------------------------------------"
sudo apt-get install -y language-pack-UTF-8
sudo apt-get install -y build-essential python-software-properties software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo add-apt-repository -y ppa:ondrej/mysql-5.7
sudo apt-get update
sudo apt-get install -y re2c libpcre3-dev gcc make


#
# Install Git and Tools
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Git"
apt-get install -y git  > /dev/null

echo -e "----------------------------------------"
echo "VAGRANT ==> tools (mc, htop, unzip etc...)"
apt-get install -y mc htop unzip grc gcc make libpcre3 libpcre3-dev lsb-core autoconf dos2unix > /dev/null

#
# Install Apache
#
#echo -e "----------------------------------------"
#echo "VAGRANT ==> Apache"
#apt-get install -y apache2  > /dev/null


#
# Install Nginx
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Nginx"
apt-get install -y nginx  > /dev/null


#
# Nginx host
#
echo -e "----------------------------------------"
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default
echo "VAGRANT ==> Setup Nginx"
cd ~
echo 'server {
    index    index.php index.html index.htm;
    set      $basepath "/srv/www";
    set      $domain $host;
    charset  utf-8;

    # check one name domain for simple application
    if ($domain ~ "^(.[^.]*)\.dev$") {
        set $domain $1;
        set $rootpath "${domain}/public/";
        set $servername "${domain}.dev";
    }

    # check multi name domain to multi application
    if ($domain ~ "^(.*)\.(.[^.]*)\.dev$") {
        set $subdomain $1;
        set $domain $2;
        set $rootpath "${domain}/${subdomain}/www/";
        set $servername "${subdomain}.${domain}.dev";
    }

    server_name $servername;

    access_log "/var/log/nginx/server.${servername}.access.log";
    error_log "/var/log/nginx/server.dev.error.log";

    root $basepath/$rootpath;

    # check file exist and send request sting to index.php
    location / {
        try_files $uri $uri/ /index.php?_url=$uri&$args;
    }

    # allow execute all php files
    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        #fastcgi_pass  127.0.0.1:9000;
		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        fastcgi_index /index.php;

        include fastcgi_params;
        fastcgi_split_path_info       ^(.+\.php)(/.+)$;
        fastcgi_param PATH_INFO       $fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    # turn off cache
    location ~* ^.+\.(js|css)$ {
        expires -1;
        sendfile off;
    }

    # disallow access to apache configs
    location ~ /\.ht {
        deny all;
    }

    # disallow access to git configs path
    location ~ /\.git {
        deny all;
    }
}' > devhosts

#
# enable host
#
echo -e "----------------------------------------"
echo "VAGRANT ==> HOST file"
sudo mv ~/devhosts /etc/nginx/sites-available/devhosts
sudo ln -s /etc/nginx/sites-available/devhosts /etc/nginx/sites-enabled/devhosts
sudo service nginx restart > /dev/null

#
# php
#
echo -e "----------------------------------------"
echo "VAGRANT ==> PHP 7"
sudo apt-get install -y php7.0-fpm php7.0-cli php7.0-common php7.0-json php7.0-opcache php7.0-mysql php7.0-phpdbg php7.0-mbstring php7.0-gd php-imagick  php7.0-pgsql php7.0-pspell php7.0-recode php7.0-tidy php7.0-dev php7.0-intl php7.0-gd php7.0-curl php7.0-zip php7.0-xml mcrypt memcached php-apcu
sudo apt-get install -y phpunit
#
# PHP Errors
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Setup PHP 7"
sudo sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/7.0/fpm/php.ini
sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php/7.0/fpm/php.ini
sudo sed -i 's/display_startup_errors = Off/display_startup_errors = On/' /etc/php/7.0/fpm/php.ini
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php/7.0/fpm/php.ini
#sudo sed -i 's/listen =/listen = /var/run/php/php7.0-fpm.sock ;/' /etc/php/7.0/fpm/pool.d/www.conf
service php7.0-fpm restart

# For zephir installtion; the following packages are needed in Ubuntu:
sudo apt-get install -y gcc make re2c libpcre3-dev php7.0-dev build-essential php7.0-zip

#
# composer
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Composer"
curl -sS https://getcomposer.org/installer | php > /dev/null
mv composer.phar /usr/local/bin/composer

#
# npm & nodejs
#
echo -e "----------------------------------------"
echo "VAGRANT ==> NPM & NodeJS"
sudo apt install -y npm
sudo apt install -y nodejs

#
# redis
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Redis Server"
apt-get install -y redis-server redis-tools
cp /etc/redis/redis.conf /etc/redis/redis.bkup.conf
sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf


echo -e "----------------------------------------"
echo "VAGRANT ==> PHP Redis"
git clone https://github.com/phpredis/phpredis.git
cd phpredis
git checkout php7
phpize
./configure
make && make install
cd ..
rm -rf phpredis
cd ~/
echo "extension=redis.so" > ~/redis.ini
cp ~/redis.ini /etc/php/7.0/mods-available/redis.ini
ln -s /etc/php/7.0/mods-available/redis.ini /etc/php/7.0/fpm/conf.d/20-redis.ini

echo -e "----------------------------------------"
echo "VAGRANT ==> Restart Redis & PHP"
service redis-server restart
service php7.0-fpm restart


#
# MySQL
#
echo -e "----------------------------------------"
echo "VAGRANT ==> MySQL"
export DEBIAN_FRONTEND=noninteractive
apt-get install -y debconf-utils -y > /dev/null
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get -q install -y mysql-server-5.7 mysql-client-5.7
sed -i 's/bind-address/bind-address = 0.0.0.0#/' /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
service mysql restart

#
# Phalcpn PHP Framework 3
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Setup Phalcon Framework 3"
cd ~/
sudo apt-add-repository ppa:phalcon/stable
sudo apt-get update
sudo apt-get install -y php7.0-phalcon
echo 'extension=phalcon.so' > /etc/php/7.0/mods-available/phalcon.ini
ln -s /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/fpm/conf.d/20-phalcon.ini
ln -s /etc/php/7.0/mods-available/phalcon.ini /etc/php/7.0/cli/conf.d/20-phalcon.ini

# Install zephir
echo -e "----------------------------------------"
echo "VAGRANT ==> Zephir"
git clone https://github.com/phalcon/zephir
cd zephir
./install -c


# Install phalcon dev tool 
echo -e "----------------------------------------"
echo "VAGRANT ==> Phalcon dev tools"
git clone https://github.com/phalcon/phalcon-devtools.git
cd phalcon-devtools
ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon

# Install phpmyadmin
echo -e "----------------------------------------"
echo "VAGRANT ==> PhpMyAdmin"
	# Download phpMyAdmin
	if [[ ! -d /srv/www/tools/public/database-admin ]]; then
		echo "Downloading phpMyAdmin 4.6.4..."
		cd /srv/www/tools
		wget -q -O phpmyadmin.tar.gz 'https://files.phpmyadmin.net/phpMyAdmin/4.6.4/phpMyAdmin-4.6.4-english.tar.gz'
		tar -xf phpmyadmin.tar.gz
		mv phpMyAdmin-4.6.4-english public/database-admin
		rm phpmyadmin.tar.gz
	else
		echo "PHPMyAdmin already installed."
	fi
	cp /srv/config/phpmyadmin-config/config.inc.php /srv/www/tools/public/database-admin/

#
# Install tools
#
echo -e "----------------------------------------"
echo "VAGRANT ==> memcacheadmin"
wget -q -O memcached-admin.tar.gz https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phpmemcacheadmin/phpMemcachedAdmin-1.2.2-r262.tar.gz
mkdir public/memcached-admin
tar -xf memcached-admin.tar.gz -C public/memcached-admin
rm memcached-admin.tar.gz

echo -e "----------------------------------------"
echo "VAGRANT ==> opcache-status"
git clone https://github.com/rlerdorf/opcache-status.git public/opcache-status

#
# Reload servers
#
echo -e "----------------------------------------"
echo "VAGRANT ==> Restart Nginx & PHP-FPM"
sudo service nginx restart
sudo service php7.0-fpm restart

#
# Add user to group
#
sudo usermod -a -G www-data ubuntu

# Used to to ensure proper services are started on `vagrant up`
#cp /srv/config/init/vvv-start.conf /etc/init/vvv-start.conf

#
#  Cleanup
#
apt-get autoremove -y
apt-get autoclean -y

#
# COMPLETE
#
echo -e "----------------------------------------"
echo -e "----------------------------------------"
echo "======>  VIRTUAL MACHINE READY"
echo "======>  TYPE 'vagrant ssh"
echo -e "----------------------------------------"
echo -e "----------------------------------------"
