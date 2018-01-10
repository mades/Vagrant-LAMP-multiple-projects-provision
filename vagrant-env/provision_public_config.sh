#!/usr/bin/env bash

#Configuring

#hosts for apache config ../progects/<project>/public
declare -a HOSTS_ARRAY=(
    app.local
    phpmyadmin.local
)

# password for root database user 
DATABASE_ROOTPASSWORD=password

# user and password for databases
DATABASE_USER=appuser
DATABASE_PASSWORD=apppassword

# Create databases <database_name>
declare -a DATABASE_NAMES_ARRAY=(
    app_db
    app2_db
)

#Import SQL to some databases. Just put files into vagrant-env/sql/import/ directory
# - sql/import/<AnyName>.<DatabaseName>.sql
# - sql/import/<AnyName>.<DatabaseName>.sql.gz


