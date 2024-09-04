FROM debian:11

# Install necessary packages and set up the MariaDB directory
RUN apt-get update && \
    apt-get -y install \
        gettext-base \
        mariadb-server \
        mariadb-client \
        procps \
        net-tools \
        curl \
        telnet \
        less && \
    mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld

# Copy and set permissions for the MariaDB configuration file
COPY ./conf/my.conf /etc/mysql/my.conf
RUN chmod 644 /etc/mysql/my.conf

# Copy the startup script
COPY ./tools/run.sh /run.sh
RUN chmod +x /run.sh

# Define a volume for MariaDB data and expose the MariaDB port
VOLUME [ "/sys/fs/cgroup", "/var/lib/mysql" ]
EXPOSE 3306

# Set the default command to execute the script
ENTRYPOINT ["/run.sh" ]

CMD ["mysqld_safe", "--bind-address=0.0.0.0"]