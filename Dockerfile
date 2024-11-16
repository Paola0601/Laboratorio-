# Usa una imagen base de Debian y asegúrate de instalar MariaDB y Apache
FROM debian:latest

# Instala Apache, Perl, MariaDB y los módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Configura MariaDB para inicializarse correctamente
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE prueba;" && \
    mysql -u root -e "USE prueba; CREATE TABLE actores (actor_id INT PRIMARY KEY AUTO_INCREMENT, nombre VARCHAR(100));"

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia el script Perl en el directorio CGI
COPY cgi-bin/basedatos.pl /usr/lib/cgi-bin/basedatos.pl
RUN chmod +x /usr/lib/cgi-bin/basedatos.pl

# Exponer el puerto 80
EXPOSE 80

# Inicia MariaDB y Apache
CMD service mysql start && apache2ctl -D FOREGROUND
