# Serveur apache
FROM debian:latest

RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-fastcgi

RUN rm /etc/apache2/sites-enabled/*

ADD conf-available /etc/apache2/conf-available
ADD sites-available /etc/apache2/sites-available
COPY bin/ /opt/docker/
RUN chmod +x /opt/docker/*.sh

RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN a2enconf servername
RUN a2ensite 000-default

# Create aliases
RUN echo 'alias ll="ls -la"' >> ~/.bashrc

EXPOSE 80

VOLUME /var/www

ENTRYPOINT ["/opt/docker/apache.sh"]
