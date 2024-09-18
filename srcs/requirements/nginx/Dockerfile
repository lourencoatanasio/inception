FROM debian:11

RUN apt-get update\
    && apt-get install -y nginx openssl inetutils-ping\
    && mkdir -p /var/www/ /etc/nginx/ssl/

RUN mkdir -p /run/nginx

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/nginx.crt \
       -keyout /etc/nginx/nginx.key \
       -subj "/C=PT/ST=Lisboa/L=Lisboa/O=42Lisboa/OU=ldiogo/CN=ldiogo/"

COPY ./conf/nginx.conf /etc/nginx/conf.d

COPY ./tools/run.sh /
RUN chmod +x /run.sh

EXPOSE 443

CMD ["/run.sh"]
