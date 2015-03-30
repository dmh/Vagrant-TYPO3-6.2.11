#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y dist-upgrade


apt-get -y install apache2 > /dev/null 2>&1

apt-get install -y php5 libapache2-mod-php5 php5-curl php5-mysql php5-gd php5-xcache php5-cli > /dev/null 2>&1

apt-get -y install imagemagick > /dev/null 2>&1


apt-get -y install git curl > /dev/null 2>&1

apt-get -y install debconf-utils > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
apt-get -y install mysql-server > /dev/null 2>&1

echo "CREATE DATABASE typo3" | mysql -uroot -p1234

# Set up vhost
cat > /etc/apache2/sites-available/000-default.conf <<'EOF'
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/public
    <Directory "/var/www/public">
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF


sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 10M/" /etc/php5/apache2/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 240/" /etc/php5/apache2/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 20M/" /etc/php5/apache2/php.ini




apt-get clean

service mysql restart
service apache2 restart


echo "Provision complete!"
