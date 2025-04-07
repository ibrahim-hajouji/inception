# buster is the latest stable release of debian
FROM debian:buster

RUN apt -y update && apt -y upgrade
RUN apt -y install mariadb-server \
        vim \
        procps
        #procps is a package that provides command line tools for viewing information about system utilization we need it for the ps command

RUN  mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && chmod -R 755 /var/lib/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# this command will copy the 50-server.cnf file from the conf folder to the /etc/mysql/mariadb.conf.d/50-server.cnf path in the container

COPY ./tools/mariadb.sh /usr/local/bin/mariadb.sh

RUN chmod +x /usr/local/bin/mariadb.sh

# this command will copy the mariadb.sh file from the tools folder to the /usr/bin/mariadb.sh path in the container
ENTRYPOINT [ "/usr/local/bin/mariadb.sh" ]
# this command will set the entrypoint of the container to the mariadb.sh file which means that when the container starts it will run the mariadb.sh file
# the mariadb.sh file will start the mariadb server and keep it running
# RUN  mysql -u root -p"root" -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root'); FLUSH PRIVILEGES;"
CMD [ "mysqld_safe" ]
# the command mysqld_safe will start the mariadb server in safe mode
