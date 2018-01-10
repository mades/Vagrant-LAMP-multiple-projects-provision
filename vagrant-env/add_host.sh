#!/usr/bin/env bash

# Configuring
CONF_vagrant_dir="/var/env"
source ${CONF_vagrant_dir}/provision_private_config.sh
source ${CONF_vagrant_dir}/provision_public_config.sh

#
# Add this host to Apache settings and batabase to MySQL
#

# host <project> in ../progects/<project>/public to be linked in Apache
ADD_HOST_NAME=$1

# database name to be created
ADD_DATABASE_NAME=$2

# database dump file to be imported
ADD_DATABASE_FILE=$2.sql


mkayTitle "Configuring apache..."
mkay "Creating directory /var/www/${ADD_HOST_NAME}/public"
mkdir -p /var/www/${ADD_HOST_NAME}/public
mkay "Website directories into ${CONF_apache_vhosts_file}"
VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/var/www/${ADD_HOST_NAME}/public"
  ServerName ${ADD_HOST_NAME}
  ServerAdmin webmaster@${ADD_HOST_NAME}
  ServerAlias ${ADD_HOST_NAME}
  <Directory "/var/www/${ADD_HOST_NAME}/public">
    AllowOverride All
    Require all granted
  </Directory>
  ErrorLog "${CONF_apache_log_dir}/${ADD_HOST_NAME}_error.log"
  CustomLog "${CONF_apache_log_dir}/${ADD_HOST_NAME}_access.log" common
</VirtualHost>
EOF
)
#sudo echo ${VHOST} >> ${CONF_apache_vhosts_file}
echo "${VHOST}" | sudo tee -a ${CONF_apache_vhosts_file}
mkay "Restart it..."
sudo service apache2 restart
mkay "done."




mkayTitle "Configuring MySQL..."
mkay "Creating... ${ADD_DATABASE_NAME}"
mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_root.cnf  -e "CREATE DATABASE IF NOT EXISTS ${ADD_DATABASE_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;;";
mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_root.cnf -e "GRANT ALL PRIVILEGES ON ${ADD_DATABASE_NAME}.* to '${DATABASE_USER}'@'%' identified by '${DATABASE_PASSWORD}'"

mkay "Importing SQL files for you..."
FULL_FILE_NAME=${CONF_vagrant_sql_import_dir}/${ADD_DATABASE_FILE}
mkay "Filename... ${FULL_FILE_NAME}"
mkay "DB name... ${ADD_DATABASE_NAME}"
if [ -f $FULL_FILE_NAME ]
then
    mkay "Import $FULL_FILE_NAME to ${DBNAME} ..."
    if [ ${FULL_FILE_NAME: -3} == ".gz" ]
    then
        mkay "Use GZip dump"
        zcat ${FULL_FILE_NAME} | mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_user.cnf ${ADD_DATABASE_NAME}
    fi
    if [ ${FULL_FILE_NAME: -4} == ".sql" ]
    then
        mkay "Use SQL dump"
        mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_user.cnf ${ADD_DATABASE_NAME} < ${FULL_FILE_NAME}
    fi
else
    mkay "Filename... ${FULL_FILE_NAME} is not exist"
fi

mkay "Restart it..."
sudo service mysql restart

mkay "done."





mkayTitle "Installation is done."
mkay "New available site on IP: http://192.168.157.55/"
mkay " - http://${ADD_HOST_NAME}/"
mkay "MySQL is available on port 3306 with username '${DATABASE_USER}' and password '${DATABASE_PASSWORD}'"


