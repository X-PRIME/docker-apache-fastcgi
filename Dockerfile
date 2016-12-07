# Serveur apache
FROM debian:latest

RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-fastcgi
RUN apt-get -y install openssl

RUN openssl req -x509 -newkey rsa:4086 -keyout etc/apache2/key.pem -out etc/apache2/cert.pem \
-days 3650 -nodes -sha256 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=docker.local"
RUN rm /etc/apache2/sites-enabled/*

ADD conf-available /etc/apache2/conf-available
ADD sites-available /etc/apache2/sites-available
COPY bin/ /opt/docker/
RUN chmod +x /opt/docker/*.sh

RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN a2enmod proxy_http
RUN a2enmod ssl
RUN a2enconf servername
RUN a2ensite 000-default
RUN a2ensite 000-default-ssl

# Create aliases
RUN echo 'alias ll="ls -la"' >> ~/.bashrc

EXPOSE 80
EXPOSE 443

VOLUME /var/www

ENTRYPOINT ["/opt/docker/apache.sh"]
