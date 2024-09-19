#!/bin/bash

set -e  # Exit on any error
cd /var/www/html


# Read the raw passwords from the credentials file
if [ -e "/run/secrets/credentials" ]; then
    # Read the first line as the admin password
    WP_ADMIN_PASS=$(sed -n '1p' /run/secrets/credentials)
    # Read the second line as the user password
    WP_USER_PASS=$(sed -n '2p' /run/secrets/credentials)
else
    echo "Credentials file not found in /run/secrets/"
    exit 1
fi

# Read database passwords from secret files
if [ -e "/run/secrets/db_password" ]; then
    DB_PASS=$(cat /run/secrets/db_password)
else
    echo "Database password file not found in /run/secrets/"
    exit 1
fi

if [ -e "/run/secrets/db_root_password" ]; then
    DB_ROOT_PASS=$(cat /run/secrets/db_root_password)
else
    echo "Database root password file not found in /run/secrets/"
    exit 1
fi

# Check if wp-config.php exists
if [ ! -e "/var/www/html/wp-config.php" ]; then
    echo "[Wordpress startup 1] Setting up WordPress"
    
    echo "[Wordpress startup 2] Updating WP-CLI tool"
    wp cli update --yes --allow-root || { echo "WP-CLI update failed"; exit 1; }
    
    echo "[Wordpress startup 3] Downloading WordPress"
    wp core download --allow-root || { echo "WordPress download failed"; exit 1; }
    
    echo "[Wordpress startup 4] Creating wp-config.php"
    wp config create --dbname=${DB_NAME} --path=/var/www/html/ --dbuser=${DB_USER} --dbpass="${DB_PASS}" --dbhost=${DB_HOST} --allow-root || { echo "wp-config.php creation failed"; exit 1; }
    
    echo "[Wordpress startup 5] Installing WordPress core"
    wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN} --admin_password="${WP_ADMIN_PASS}" --admin_email=${WP_ADMIN_EMAIL} --allow-root || { echo "WordPress core install failed"; exit 1; }
    
    echo "[Wordpress startup 6] Creating WordPress default user"
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASS}" --role=author --display_name="${DB_USER}" --allow-root || { echo "WordPress default user creation failed"; exit 1; }
    
    echo "[Wordpress startup 7] Installing WordPress theme"
    wp theme install bravada --activate --allow-root
    wp theme status bravada --allow-root
    
    echo "[Wordpress startup 8] Setting WP_HOME and WP_SITEURL"
    wp option update home "https://${DOMAIN_NAME}" --allow-root || { echo "Failed to set WP_HOME"; exit 1; }
    wp option update siteurl "https://${DOMAIN_NAME}" --allow-root || { echo "Failed to set WP_SITEURL"; exit 1; }
else
    echo "WordPress is already installed"
fi

echo "[Wordpress startup] Starting WordPress FastCGI on port 9000."

exec /usr/sbin/php-fpm7.4 -F -R


