# Vagrant LAMP multiple projects provision
Vagrant Apache MySQL PHP7 multiple projects provision

## Hosts settings
Add to `hosts`:
```
192.168.157.55 app.local
192.168.157.55 phpmyadmin.local
```

## VM Installation and provision

Make Directory for you vagrant project
```bash
mkdir vagrant-project
cd ./vagrant-project/
```

Clone current git repository
```bash
git clone https://github.com/madeS/Vagrant-LAMP-multiple-projects-provision.git .
```

Move to `vagrant-env` dirrectory
```bash
cd ./vagrant-env/
```
Provision use triggers for export SQL before machine has been destroyed. So, we need install special plugin
```bash
vagrant plugin install vagrant-triggers
```
Create and up provision to machine
```bash
vagrant up
```

**IT IS ALL.**
Check that you can open http://app.local/phpinfo.php in your browser.


VM started with IP `192.168.157.55` and has shared directories
```
/var/www <=> ./projects
/var/env <=> ./vagrant-env
```
http://phpmyadmin.local/ - installed phpMyAdmin

## Shutdown and restart machine
You can shutdown machine
```
vagrant halt
```
You can startup machine
```
vagrant up
```
**Since Apache starts earlier than the mounted disks, you may have problems with unstarted apache.**
For resolve it, connect to your machine by ssh
```
vagrant ssh
```
Restart your apache
```bash
sudo service apache2 restart
```
Check that you can open http://app.local/phpinfo.php in your browser.

## Additional vhosts creation

For example, we need add new project with host name `laravel_example.local` and database name `laravel_db`

> You can put your SQL script for import to created database data  in `./vagrant-env/sql/import/laravel_db.sql` if it necessary.

Add to `hosts`:
```
192.168.157.55 laravel_example.local
```

Connect to your machine
```
vagrant ssh
```
Run bash script for add new host
```bash
cd /var/env
./add_host.sh laravel_example.local laravel_db
```

it is all, now you have connected  http://laravel_example.local/ to `./projects/laravel_example.local/public` directory

Go to this directory and install Laravel
```bash
cd /var/www/laravel_example.local
rm -rf /var/www/laravel_example.local/public
composer create-project --prefer-dist laravel/laravel .
```

Enjoy!
