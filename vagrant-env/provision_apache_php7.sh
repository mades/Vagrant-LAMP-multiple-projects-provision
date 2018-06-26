#!/usr/bin/env bash

# Configuring
CONF_vagrant_dir="/var/env"
source ${CONF_vagrant_dir}/provision_private_config.sh
source ${CONF_vagrant_dir}/provision_public_config.sh




# LETS GO...


mkayTitle "Configuring Locale..."
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
sudo dpkg-reconfigure -f noninteractive locales
mkay "done."




mkayTitle "Update packages..."
sudo apt-get -y update
sudo apt-get -y upgrade
mkay "done."




mkayTitle "Installing default apps..."
sudo apt-get -y install git curl vim htop mc pv
sudo apt-get -y install ngrok
# sudo apt-get -y install nodejs npm subversion
# sudo apt-get -y install unixodbc memcached sendmail
# sudo apt-get -y install rabbitmq-server redis-server
sudo apt-get -y install python-software-properties software-properties-common
mkay "done."




mkayTitle "Installing Apache..."
sudo apt-get -y install apache2 libapache2-mod-fastcgi
mkay "done."




mkayTitle "Installing MySQL..."
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${DATABASE_ROOTPASSWORD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${DATABASE_ROOTPASSWORD}"

mkay "Installation started"
sudo apt-get -y install mysql-server
sudo apt-get -y install mysql-client
mkay "done."




mkayTitle "Installing PHP"
mkay "Adding repository..."
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update

# mkay "Remove old php5..."
# sudo apt-get purge php5-fpm -y
# sudo apt-get --purge autoremove -y

mkay "Install PHP ${CONF_php_version}..."
sudo apt-get -y install php${CONF_php_version} php${CONF_php_version}-fpm

mkay "Install php modules..."
sudo apt-get -y install mcrypt php${CONF_php_version}-mcrypt
sudo apt-get -y install php${CONF_php_version}-cli
sudo apt-get -y install php${CONF_php_version}-curl
sudo apt-get -y install php${CONF_php_version}-intl
sudo apt-get -y install php${CONF_php_version}-mbstring
sudo apt-get -y install php${CONF_php_version}-xml
sudo apt-get -y install php${CONF_php_version}-mysql
sudo apt-get -y install php${CONF_php_version}-json
sudo apt-get -y install php${CONF_php_version}-cgi
sudo apt-get -y install php${CONF_php_version}-gd
#sudo apt-get -y install php${CONF_php_version}-imagick
#sudo apt-get -y install php${CONF_php_version}-bz2
sudo apt-get -y install php${CONF_php_version}-zip

#install pear
wget http://pear.php.net/go-pear.phar
sudo php go-pear.pha

mkay "Install php apache module..."
sudo apt-get -y install libapache2-mod-php${CONF_php_version}
mkay "done."




mkayTitle 'Installing Composer...'
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
mkay "done."




if [ ${CONF_nodejs_install} -eq 1 ]
then
    mkayTitle "Installing NodeJS..."
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt-get install -y nodejs
    npm install npm@latest -g
    mkay "done."
else
    mkayTitle "Installing NodeJS skipped by settings."
fi





mkayTitle "Installing phpMyAdmin..."
mkay "installing: https://files.phpmyadmin.net/phpMyAdmin/$(echo ${CONF_phpmyadmin_version}| cut -d'-' -f 2)/${CONF_phpmyadmin_version}.tar.gz"
wget -k -nv https://files.phpmyadmin.net/phpMyAdmin/$(echo ${CONF_phpmyadmin_version}| cut -d'-' -f 2)/${CONF_phpmyadmin_version}.tar.gz
sudo tar -xzf ${CONF_phpmyadmin_version}.tar.gz -C /var/www/phpmyadmin.local
#sudo rm ${CONF_phpmyadmin_version}.tar.gz
sudo mv ${CONF_phpmyadmin_version}.tar.gz /var/www/phpmyadmin.local/${CONF_phpmyadmin_version}.tar.gz
sudo mv -v /var/www/phpmyadmin.local/${CONF_phpmyadmin_version}/* /var/www/phpmyadmin.local/public/
sudo rm -rf /var/www/phpmyadmin.local/${CONF_phpmyadmin_version}




mkayTitle "Configuring PHP..."

a2enconf php${CONF_php_version}-fpm
sudo service apache2 reload


mkayTitle "Installing XDebug..."
sudo apt-get install php-xdebug

XDEBUGCONF=$(cat <<EOF
xdebug.remote_enable = On
xdebug.remote_port = 9001
xdebug.remote_handler = "dbgp"
xdebug.remote_host = "10.0.2.2"
;xdebug.idekey = "IDEDEBUG"
xdebug.remote_autostart = On
;xdebug.remote_connect_back = 1
;xdebug.remote_log = "/var/www/xdebug.log"
xdebug.profiler_enable = 0
;xdebug.profiler_output_dir = "/var/www/"
;xdebug.profiler_append = 1
;xdebug.profiler_enable_trigger = 1
;xdebug.profiler_output_name = "xdebug.out.%t"
EOF
)
# request_terminate_timeout = 3600 for nginx
echo "${XDEBUGCONF}" | sudo tee -a ${CONF_xdebug_config_file}

sudo service apache2 reload

mkay "done."




mkayTitle "Configuring apache..."

mkay "ServerName into ${CONF_apache_config_file}"
sudo echo "ServerName localhost" >> ${CONF_apache_config_file}
sudo mkdir -p ${CONF_apache_log_dir} -m 0777

mkay "Website directories into ${CONF_apache_vhosts_file}"
# Setup hosts file
for i in ${HOSTS_ARRAY[@]}; do
    VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/var/www/${i}/public"
  ServerName ${i}
  ServerAdmin webmaster@${i}
  ServerAlias ${i}
  <Directory "/var/www/${i}/public">
    AllowOverride All
    Require all granted
  </Directory>
  ErrorLog "${CONF_apache_log_dir}/${i}_error.log"
  CustomLog "${CONF_apache_log_dir}/${i}_access.log" common
</VirtualHost>
EOF
)
    #sudo echo "${VHOST}" >> ${CONF_apache_vhosts_file}
    echo "${VHOST}" | sudo tee -a ${CONF_apache_vhosts_file}
done

mkay "Restart it..."
sudo a2enmod actions fastcgi rewrite
sudo service apache2 restart
mkay "done."




mkayTitle "Configuring MySQL..."

sudo mkdir -p ${CONF_mysql_cnf} -m 0777
VMYSQLROOT=$(cat <<EOF
[client]
user = root
password = ${DATABASE_ROOTPASSWORD}
host = localhost
EOF
)
sudo echo "${VMYSQLROOT}" > ${CONF_mysql_cnf}/mysql_root.cnf
sudo chmod 0644 ${CONF_mysql_cnf}/mysql_root.cnf
VMYSQLUSER=$(cat <<EOF
[client]
user = ${DATABASE_USER}
password = ${DATABASE_PASSWORD}
host = localhost
EOF
)
sudo echo "${VMYSQLUSER}" > ${CONF_mysql_cnf}/mysql_user.cnf
sudo chmod 0644 ${CONF_mysql_cnf}/mysql_user.cnf

mkay "Access from anything..."
sudo sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${CONF_mysql_config_file}

mkay "Creating databeses for you..."
for DB_NAME in ${DATABASE_NAMES_ARRAY[@]}; do
    mkay "Creating... ${DB_NAME}"
    mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_root.cnf  -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;;";
    mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_root.cnf -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* to '${DATABASE_USER}'@'%' identified by '${DATABASE_PASSWORD}'"
    #mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_root.cnf -e "GRANT ALL PRIVILEGES ON *.* to '${DATABASE_USER}'@'%' identified by '${DATABASE_PASSWORD}'"
done

mkay "Importing SQL files for you..."
for FULL_FILE_NAME in ${CONF_vagrant_sql_import_dir}/*; do
    DBNAME=$(echo $FULL_FILE_NAME| cut -d'.' -f 2)
    mkay "Filename... ${FULL_FILE_NAME}"
    mkay "DB name... ${DBNAME}"

    if [ -f $FULL_FILE_NAME ]
    then
        mkay "Import $FULL_FILE_NAME to ${DBNAME} ..."
        if [ ${FULL_FILE_NAME: -3} == ".gz" ]
        then
            mkay "Use GZip dump"
            zcat ${FULL_FILE_NAME} | mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_user.cnf ${DBNAME}
        fi
        if [ ${FULL_FILE_NAME: -4} == ".sql" ]
        then
            mkay "Use SQL dump"
            mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_user.cnf ${DBNAME} < ${FULL_FILE_NAME}
        fi
        
	fi
done

mkay "Restart it..."
sudo service mysql restart

sudo chmod +x /var/env/add_host.sh
sudo chmod +x /var/env/before_destroy.sh 

mkay "done."





mkayTitle "Installation is done."
mkay "Available sites on IP: http://192.168.157.55/"
for site in ${HOSTS_ARRAY[@]}; do
    mkay " - http://${site}/"
done
mkay "MySQL is available on port 3306 with username '${DATABASE_USER}' and password '${DATABASE_PASSWORD}'"


