# Usa una imagen base de MariaDB
FROM mariadb:latest

# Copia el archivo de configuración SQL al contenedor
COPY init.sql /docker-entrypoint-initdb.d/

# Instala Apache y Perl
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia el script Perl en el directorio CGI
COPY cgi-bin/basedatos.pl /usr/lib/cgi-bin/basedatos.pl
RUN chmod +x /usr/lib/cgi-bin/basedatos.pl

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache y MariaDB
CMD ["sh", "-c", "service mysql start && apache2ctl -D FOREGROUND"]
