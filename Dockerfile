# Imagen base Debian para configurar Apache, CGI y MariaDB
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

# Copiar configuración personalizada de CGI
COPY conf/cgi-bin.conf /etc/apache2/conf-available/cgi-bin.conf
RUN a2enconf cgi-bin

# Copiar scripts CGI al directorio correspondiente
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*

# Copiar archivo index.html al directorio de Apache
COPY index.html /var/www/html/index.html

# Copiar directorio de estilos CSS al servidor web
COPY css/ /var/www/html/css/

# Copiar archivo de inicialización de la base de datos
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Exponer los puertos necesarios
EXPOSE 80 3306

# Comando para iniciar MariaDB y Apache al mismo tiempo
CMD ["sh", "-c", "mysqld & apachectl -D FOREGROUND"]
