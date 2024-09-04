#!/bin/sh

# Add entry to /etc/hosts
echo "127.0.0.1 ldiogo.42.fr" >> /etc/hosts

# Start Nginx
nginx -g 'daemon off;'