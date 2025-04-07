#!/bin/bash

# PHP-FPM needs a special folder to store a socket file (used for communication with a Web-server, we create it to be sure it exists)
mkdir -p /run/php

# since by default PHP_FPM listens for connections using socket file, we will change it to listen on port 9000 instead (because Docker containers communicate over network ports, not sockets)
sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
# sed is a tool used for find-replace operations in text files, -i is used for editing the file and saving it (without it, it will just print the result to stdout instead of changing the file)

# wp-config.php is the file that contains WordPress database settings, so if it exists, it means WordPress is already installed and no need to reinstall
if [ -f "/var/www/wordpress/wp-config.php" ]; then
    exec "$@"
    exit 0
fi


# install WordPress command line interface to install WordPress using it instead of the web interface
if [ ! -f "/usr/local/bin/wp" ]; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi
# we move it to /usr/local/bin/wp because it is a directory that is in the PATH variable, so we can run it from anywhere in the terminal

# ensure the WordPress directory exists (the one where WordPress will be installed)
if [ ! -d "/var/www/html/wordpress" ]; then
    mkdir -p /var/www/html/wordpress
fi

cd /var/www/html/wordpress
rm -rf /var/www/html/wordpress/*

# download the latest version of WordPress
wp core download --allow-root
# core is a command to download the latest version of WordPress, --allow-root is used to run the command as root (because we are running the script as root)

# create a wp-config.php file with the database settings (WordPress needs database credentials to store website data)
wp config create --allow-root \
                 --dbname="$DB_NAME" \
                 --dbuser="$DB_USER" \
                 --dbpass="$DB_PASSWORD" \
                 --dbhost="mariadb:3306" \
                 --path="/var/www/html/wordpress/"

# install WordPress
wp core install --allow-root \
                --url="$WORDPRESS_URL" \
                --title="$WORDPRESS_TITLE" \
                --admin_user="$WORDPRESS_ADMIN_USER" \
                --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
                --admin_email="$WORDPRESS_ADMIN_EMAIL"

# creating an additional user
wp user create --allow-root \
               "$WORDPRESS_USER" \
               "$WORDPRESS_USER_EMAIL" \
               --role="$WORDPRESS_USER_ROLE" \
               --user_pass="$WORDPRESS_USER_PASSWORD"

chmod -R g+rw /var/www/html
chown -R www-data:www-data /var/www/html
# role is the user role (admin, editor, author, contributor, subscriber)

exec "$@"

