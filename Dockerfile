# Usa una imagen base de Debian para instalar Apache, Perl y MariaDB
FROM debian:latest

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia los scripts CGI al directorio CGI
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*.pl

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Copia el archivo SQL inicial
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Ajusta los permisos para los scripts de inicialización de MariaDB
RUN chmod 644 /docker-entrypoint-initdb.d/init.sql

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache y MariaDB en el contenedor
CMD ["bash", "-c", "mysqld & apache2ctl -D FOREGROUND"]
