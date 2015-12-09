#!/bin/sh

# Variables
DB_PASSWORD='TYPE_YOUR_PASSWORD_HERE'
PMA_PASSWORD='TYPE_YOUR_PASSWORD_HERE'
APT_OPTIONS='-y -o dir::cache::archives=/vagrant/cache/apt'
DEBIAN_FRONTEND=noninteractive

# Comment out "AcceptEnv LANG*" in OpenSSH
sed -i -e 's@^AcceptEnv LANG@#AcceptEnv LANG@g' /etc/ssh/sshd_config
service ssh restart

# apt-get
rm -fr /var/lib/apt/lists/*
add-apt-repository -y ppa:ondrej/php5-5.6
# sed -i -e 's@http://archive.ubuntu.com/ubuntu@mirror://mirrors.ubuntu.com/mirrors.txt@g' /etc/apt/sources.list
apt-get ${APT_OPTIONS} update
apt-get ${APT_OPTIONS} install pwgen

# Check if passwords are default values, and randomize
if [ ${DB_PASSWORD} = 'TYPE_YOUR_PASSWORD_HERE' ]; then
  DB_PASSWORD=`pwgen -1 32`
  echo "[MySQL] ${DB_PASSWORD}"
fi

if [ ${PMA_PASSWORD} = 'TYPE_YOUR_PASSWORD_HERE' ]; then
  PMA_PASSWORD=`pwgen -1 32`
  echo "[phpMyAdmin] ${PMA_PASSWORD}"
fi

##### Apache HTTP Server
apt-get ${APT_OPTIONS} install apache2
cp /vagrant/conf/virtualhost.conf /etc/apache2/sites-available/000-default.conf
service apache2 restart

##### MySQL
# Configure preconfiguration for MySQL Community Server 5.7
debconf-set-selections << EOS
mysql-apt-config mysql-apt-config/select-server select mysql-5.7
mysql-apt-config mysql-apt-config/select-workbench select none
mysql-apt-config mysql-apt-config/select-mysql-utilities select none
mysql-apt-config mysql-apt-config/select-product select Apply
mysql-apt-config mysql-apt-config/select-connector-odbc select
mysql-apt-config mysql-apt-config/select-connector-python select none
mysql-apt-config mysql-apt-config/select-router select none
mysql-community-server mysql-community-server/root-pass password ${DB_PASSWORD}
mysql-community-server mysql-community-server/re-root-pass password ${DB_PASSWORD}
EOS

# Get MySQL APT Repository
wget https://dev.mysql.com/get/mysql-apt-config_0.5.3-1_all.deb

# install MySQL APT Repository
dpkg -i mysql-apt-config_0.5.3-1_all.deb

# Install MySQL Community Server 5.7
apt-get update
apt-get ${APT_OPTIONS} install mysql-community-server

##### PHP
apt-get ${APT_OPTIONS} install php5 php5-cli php5-mysql php5-mcrypt libapache2-mod-php5
php5enmod mcrypt
service apache2 restart

##### phpMyAdmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${PMA_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${PMA_PASSWORD}" | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
apt-get ${APT_OPTIONS} install phpmyadmin
