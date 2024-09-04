FROM debian:11

# Add the Sury repository for PHP 7.4
RUN apt-get update && apt-get install -y lsb-release apt-transport-https ca-certificates wget && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring

# Install WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create PHP-FPM run directory
RUN mkdir /run/php/ && chmod 755 /run/php/

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's+listen = /run/php/php7.4-fpm.sock+listen = 9000+g' /etc/php/7.4/fpm/pool.d/www.conf

# Copy entrypoint script
COPY ./conf/wp-entrypoint.sh /tmp/wp-entrypoint.sh
RUN chmod +x /tmp/wp-entrypoint.sh

# Expose port used by PHP-FPM
EXPOSE 9000

# WordPress configuration
ENTRYPOINT ["/tmp/wp-entrypoint.sh"]
