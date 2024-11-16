# Usa una imagen base de MariaDB
FROM mariadb:latest

# Instala Apache y Perl
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    && apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Copia el script Perl al directorio CGI
COPY cgi-bin/basedatos.pl /usr/lib/cgi-bin/basedatos.pl
RUN chmod +x /usr/lib/cgi-bin/basedatos.pl

# Copia el archivo SQL para inicialización de MariaDB
COPY init.sql /docker-entrypoint-initdb.d/

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto 80
EXPOSE 80

# Inicia Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
