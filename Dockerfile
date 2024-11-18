# Imagen base con soporte para Perl y CGI
FROM debian:latest

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    mariadb-server \
    libdbi-perl \
    libdbd-mysql-perl \
    curl \
    && apt-get clean

# Habilitar CGI en Apache
RUN a2enmod cgi

# Configurar directorio para scripts CGI
RUN mkdir -p /usr/lib/cgi-bin
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*

# Configurar directorio HTML
COPY html/ /var/www/html/

# Configurar base de datos MariaDB
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Exponer los puertos
EXPOSE 80 3306

# Iniciar Apache y MariaDB al iniciar el contenedor
CMD service mysql start && apachectl -D FOREGROUND
