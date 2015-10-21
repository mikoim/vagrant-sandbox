#!/bin/sh

# Variables
DB_PASSWORD='TYPE_YOUR_PASSWORD_HERE'
PMA_PASSWORD='TYPE_YOUR_PASSWORD_HERE'
APT_OPTIONS='-qq -o dir::cache::archives=/vagrant/cache/apt'

# Comment out "AcceptEnv LANG*" in OpenSSH
sed -i -e 's@^AcceptEnv LANG@#AcceptEnv LANG@g' /etc/ssh/sshd_config
service ssh restart

# apt-get
add-apt-repository -y ppa:ondrej/php5-5.6
sed -i -e 's@//archive.ubuntu.com/@//jp.archive.ubuntu.com/@g' /etc/apt/sources.list
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

# Apache HTTP Server
apt-get ${APT_OPTIONS} install apache2
cp /vagrant/conf/virtualhost.conf /etc/apache2/sites-available/000-default.conf
service apache2 restart

# MySQL
echo "mysql-server-5.6 mysql-server/root_password password ${DB_PASSWORD}" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password ${DB_PASSWORD}" | debconf-set-selections
apt-get ${APT_OPTIONS} install mysql-server-5.6 mysql-client-5.6
update-rc.d mysql defaults

# PHP
apt-get ${APT_OPTIONS} install php5 php5-cli php5-mysql php5-mcrypt libapache2-mod-php5
php5enmod mcrypt
service apache2 restart

# phpMyAdmin
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${PMA_PASSWORD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${PMA_PASSWORD}" | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
apt-get ${APT_OPTIONS} install phpmyadmin
