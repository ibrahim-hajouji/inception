#!/bin/bash

# PHP-FPM needs a secial folder to store a socket file (used for communication with a Web-server, we create it to be sure it exixts)
mkdir -p /run/php

# since by default PHP_FPM listens for connections using socket file, we will change it to listen on port 9000 instead (bcs Docker containers communicate over network ports not sockets)
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
# sed is a tool used for find-replace operations in text files, -i is used to edit the file and save (without it it will just print in stdout the result instead of change it in the file)
# s/oldstring/newstring/g; s stand for subtitute the old with new and g to replace all the occurences in the file

# wp-config.php is the file taht contains wordress databse settings, s if it exists it means wordpress is already installed so no need to reinstallation
if [ -f "/var/www/wordpress/wp-config.php" ]; then
    exec "$@"
    exit 0
fi

# install Wordpress command line interface to to install wordpress using it instead of the web interface
if [ ! -d "/usr/local/bin/wp/" ]; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi
# we move it to /usr/local/bin/wp bcs it is a directory that is in the PATH variable so we can run it from anywhere in the terminal

# ensure the wordpress directory exists (the one where wordpress will be installed)
if [ ! -d "/var/www/wordpress" ]; then
    mkdir -p /var/www/wordpress
fi

# delete any old files to install a fresh copy
cd /var/www/wordpress && rm -rf *

# download the latest version of wordpress
wp core download --allow-root
# core is a command to download the latest version of wordpress, --allow-root is used to run the command as root (bcs we are running the script as root)

# create a wp-config.php file with the database settings (wp need database credentials to store website data)
wp config create    --allow-root \ 
                    --dbname=$DB_NAME \
                    --dbuser=$DB_USER \
                    --dbpass=$DB_PASSWORD \ 
                    --dbhost='mariadb:3306' \
                    --path='/var/www/html/wordpress/'

# install wordpress
wp core install     --allow-root \
                    --url=$WORDPRESS_URL \
                    --title=$WORDPRESS_TITLE \
                    --admin_user=$WORDPRESS_ADMIN_USER \
                    --admin_password=$WORDPRESS_ADMIN_PASSWORD \
                    --admin_email=$WORDPRESS_ADMIN_EMAIL

# creating an additional user
wp user create      --allow-root \
                    $WORDPRESS_USER \
                    $WORDPRESS_USER_EMAIL \
                    --role=$WORDPRESS_USER_ROLE \
                    --user_pass=$WORDPRESS_USER_PASSWORD
# role is the user role (admin, editor, author, contributor, subscriber)

exec "$@"


