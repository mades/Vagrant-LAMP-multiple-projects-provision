#!/usr/bin/env bash

# Inner config, dont touch
CONF_apache_config_file="/etc/apache2/httpd.conf"
CONF_apache_vhosts_file="/etc/apache2/sites-enabled/000-default.conf"
CONF_mysql_config_file="/etc/mysql/mysql.conf.d/mysqld.cnf"
CONF_apache_log_dir="/var/www/apache_log"
CONF_mysql_cnf="/etc/mysql/users_cnf"
CONF_vagrant_sql_import_dir="/var/env/sql/import"
CONF_vagrant_sql_export_dir="/var/env/sql/export"
CONF_php_version="7.1"
CONF_phpmyadmin_version="phpMyAdmin-4.7.4-all-languages"
CONF_xdebug_config_file="/etc/php/${CONF_php_version}/mods-available/xdebug.ini"
CONF_nodejs_install=1
mkayTitle() {
	echo -e "\033[0;30m\033[42m * Mkay, now $1 * \033[0m"
}
mkay() {
	echo -e " * Mkay, $1 * "
}

