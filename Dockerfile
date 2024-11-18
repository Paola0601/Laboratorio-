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

# Copiar archivos CGI al directorio correspondiente
COPY cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*

# Copiar el archivo index.html al directorio de Apache
COPY index.html /var/www/html/index.html

# Copiar archivo de inicialización de la base de datos
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Exponer los puertos necesarios
EXPOSE 80 3306

# Comando para iniciar MariaDB y Apache al mismo tiempo
CMD ["sh", "-c", "mysqld & apachectl -D FOREGROUND"]

