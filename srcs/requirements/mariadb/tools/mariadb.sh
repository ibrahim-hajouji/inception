#!/bin/bash

# Start MariaDB service
service mysql start 
echo "MariaDB service started"

cat << EOF > mariadb.sql
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD';
FLUSH PRIVILEGES;
USE $DB_NAME;
CREATE TABLE students (login VARCHAR(255), level INT);
INSERT INTO students (login, level) VALUES ('ihajouji', 7);
EOF

mysql -u root < mariadb.sql

service mysql stop
echo "MariaDB service stopped"
# we stopped the service to ensure that the initial setup is done before the container starts
exec "$@"
# this cmnd replace the current running process with the one passed to it which is in our case CMD ["mysqld_safe"]