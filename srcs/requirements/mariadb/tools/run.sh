#!/bin/bash

set -e  # Exit on any error

# Read passwords from Docker secrets
if [ -e "/run/secrets/db_root_password" ]; then
    DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
    echo "Root password file not found in /run/secrets/"
    exit 1
fi

if [ -e "/run/secrets/db_password" ]; then
    DB_PASS=$(cat /run/secrets/db_password)
else
    echo "Database user password file not found in /run/secrets/"
    exit 1
fi

# Check if the database directory exists
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    echo "Initializing database..."

    # Start MariaDB service
    service mariadb start

    sleep 1

    # Secure installation
    mysql_secure_installation << END

Y
$DB_ROOT_PASSWORD
$DB_ROOT_PASSWORD
Y
Y
Y
Y
END

    sleep 1
    # Create database and user
    mysql -u root -e "CREATE DATABASE $DB_NAME;"
    mysql -u root -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';"
    mysql -u root -p$DB_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown

else
    sleep 1
    echo "Database is already configured"
fi

# Create a configuration file to allow MariaDB to listen on all interfaces
echo "[mysqld]
bind-address = 0.0.0.0" > /etc/mysql/mariadb.conf.d/99-custom.cnf

echo "Starting MariaDB..."
exec mysqld --user=mysql --datadir="/var/lib/mysql"

