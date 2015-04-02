#!/usr/bin/env bash

echo "=============================="
echo "Starting Provision..."
echo "=============================="

if [ ! -d "/var/www/typo3" ]; then
    echo "=============================="
    echo "Provision Stopped!!!"
    echo "=============================="
    echo "Warning!!!"
    echo "Missed typo3 source files."
    echo "Please run [bower install] to install all dependancies"
fi

if [ -d "/var/www/typo3" ]; then

# Non-interactive mode
export DEBIAN_FRONTEND=noninteractive

# Update apt-get
echo -e "Updating apt-get... \r1% "
apt-get update > /dev/null 2>&1

# Install Apache
echo -e "Installing Apache... \r10% "
apt-get -y install apache2 > /dev/null 2>&1

# Install PHP5 + libraries
echo -e "Installing PHP5 + libraries... \r20% "
apt-get install -y php5 libapache2-mod-php5 php5-curl php5-mysql > /dev/null 2>&1

# Install imagemagick (for TYPO3)
echo -e "Installing Imagemagick... \r50% "
apt-get -y install imagemagick > /dev/null 2>&1


# Install git & curl
echo -e "Installing git & curl... \r60% "
apt-get -y install git curl > /dev/null 2>&1

# Install MySQL
echo -e "Installing MySQL... \r70% "
apt-get -y install debconf-utils > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
apt-get -y install mysql-server > /dev/null 2>&1

# Create MySQL DB for TYPO3
echo -e "Creating TYPO3 DB & VirtualHost... \r92% "
echo "CREATE DATABASE typo3" | mysql -uroot -p1234
mysql -uroot -p1234 typo3 < /var/www/typo3db/typo3db.sql


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

# PHP.ini changes
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 10M/" /etc/php5/apache2/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 240/" /etc/php5/apache2/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 20M/" /etc/php5/apache2/php.ini

apt-get clean > /dev/null 2>&1

# Restart MySQL
echo -e "Restarting MySQL & Apache... \r95% "
service mysql restart > /dev/null 2>&1
# Restart Apache
service apache2 restart > /dev/null 2>&1
echo "Provision complete!"
sleep 2
echo "=============================="
echo "========== INFO =============="
echo "=============================="
echo "VM IP"
ifconfig | perl -nle'/dr:(\S+)/ && print $1'
echo "=============================="
echo "=============================="
echo "TYPO3 login: admin"
echo "TYPO3 password: admin1234"
echo "TYPO3 install tools password: admin1234"
echo "------------------------------"
echo "DB name: typo3"
echo "DB login: root"
echo "DB password: 1234"
echo "=============================="
echo "=============================="
echo "Open site in browser using IP address"

fi
