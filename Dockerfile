# Usa una imagen base de Ubuntu 20.04
FROM ubuntu:20.04

# Configuración de entorno para evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod cgi

# Crear directorios necesarios y asignar permisos
RUN mkdir -p /var/www/html/css /var/www/html/images /usr/lib/cgi-bin && \
    chmod -R 755 /var/www/html && \
    chmod +x /usr/lib/cgi-bin

# Copia los scripts Perl al directorio CGI
COPY basedatos.pl /usr/lib/cgi-bin/basedatos.pl
COPY ejercicio2/ejercicio2.pl /usr/lib/cgi-bin/ejercicio2.pl
COPY ejercicio3/ejercicio3.pl /usr/lib/cgi-bin/ejercicio3.pl
COPY ejercicio4/ejercicio4.pl /usr/lib/cgi-bin/ejercicio4.pl
COPY ejercicio5/formulario-ej5.html /var/www/html/index.html

RUN chmod +x /usr/lib/cgi-bin/*.pl

# Copia los archivos HTML, CSS e imágenes
COPY ejercicio5/formulario-ej5.html /var/www/html/
COPY ejercicio5/styles.css /var/www/html/css/
COPY ejercicio5/unsa-logo.png /var/www/html/images/

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Configura MariaDB y prepara la base de datos
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE prueba;" && \
    mysql -u root -e "USE prueba; \
        CREATE TABLE actores (actor_id INT PRIMARY KEY AUTO_INCREMENT, nombre VARCHAR(100)); \
        CREATE TABLE peliculas (pelicula_id INT PRIMARY KEY AUTO_INCREMENT, nombre VARCHAR(100), year INT, vote INT, score DECIMAL(3,1)); \
        CREATE TABLE casting (casting_id INT PRIMARY KEY AUTO_INCREMENT, pelicula_id INT, actor_id INT, papel VARCHAR(100), \
            FOREIGN KEY (pelicula_id) REFERENCES peliculas(pelicula_id) ON DELETE CASCADE, \
            FOREIGN KEY (actor_id) REFERENCES actores(actor_id) ON DELETE CASCADE);" && \
    mysql -u root -e "USE prueba; \
        INSERT INTO actores (nombre) VALUES ('Robert Downey Jr.'), ('Scarlett Johansson'), ('Chris Hemsworth'); \
        INSERT INTO peliculas (nombre, year, vote, score) VALUES ('Avengers: Endgame', 2019, 8500, 8.4), ('Iron Man', 2008, 4000, 7.9), ('Thor', 2011, 3200, 7.0); \
        INSERT INTO casting (pelicula_id, actor_id, papel) VALUES (1, 1, 'Iron Man'), (1, 2, 'Black Widow'), (1, 3, 'Thor'), (2, 1, 'Iron Man'), (3, 3, 'Thor');"

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache y MariaDB
CMD ["sh", "-c", "mysqld_safe & apache2ctl -D FOREGROUND"]

