#!/bin/bash

# Configuring
CONF_vagrant_dir="/var/env"
source ${CONF_vagrant_dir}/provision_private_config.sh
source ${CONF_vagrant_dir}/provision_public_config.sh


databases=`mysql --defaults-extra-file=${CONF_mysql_cnf}/mysql_user.cnf -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
 
for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        #mysqldump --force --opt --user=${DATABASE_USER} --password=${DATABASE_PASSWORD} --databases $db > ${CONF_vagrant_sql_export_dir}/`date +%Y%m%d%H`.$db.sql
        mysqldump --defaults-extra-file=${CONF_mysql_cnf}/mysql_user.cnf --force --opt --databases $db > ${CONF_vagrant_sql_export_dir}/`date +%Y%m%d%H`.$db.sql
        gzip ${CONF_vagrant_sql_export_dir}/`date +%Y%m%d%H`.$db.sql
    fi
done