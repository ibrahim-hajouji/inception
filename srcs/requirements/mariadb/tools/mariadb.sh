#!/bin/bash
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chmod 755 /var/run/mysqld

# Start MariaDB service
service mysql start
echo "MariaDB service started"

cat << EOF > mariadb.sql
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'wordpress.inception' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'wordpress.inception' WITH GRANT OPTION;
USE $DB_NAME;
CREATE TABLE IF NOT EXISTS students (login VARCHAR(255), level INT);
INSERT INTO students (login, level) VALUES ('ihajouji', 7);
FLUSH PRIVILEGES;
EOF

mysql -u root < mariadb.sql

service mysql stop
echo "MariaDB service stopped"
# we stopped the service to ensure that the initial setup is done before the container starts

exec "$@"
# this cmnd replace the current running process with the one passed to it which is in our case CMD ["mysqld_safe"]
