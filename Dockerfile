# Usa una imagen base de Debian para instalar Apache, Perl y MariaDB
FROM debian:latest

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi
# Crear directorio para HTML
RUN mkdir -p /var/www/html

# Dar permisos a la carpeta /var/www/html para poder copiar los archivos HTML, CSS, e imágenes
RUN chmod -R 755 /var/www/html
# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia el script Perl en el directorio CGI
COPY basedatos.pl /usr/lib/cgi-bin/basedatos.pl
RUN chmod +x /usr/lib/cgi-bin/basedatos.pl

#Copia el script Perl EJERCICIO2 en el directorio CGI
COPY ejercicio2/ejercicio2.pl /usr/lib/cgi-bin/ejercicio2.pl
RUN chmod +x /usr/lib/cgi-bin/ejercicio2.pl

#Copia el script Perl EJERCICIO3 en el directorio CGI
COPY ejercicio3/ejercicio3.pl /usr/lib/cgi-bin/ejercicio3.pl
RUN chmod +x /usr/lib/cgi-bin/ejercicio3.pl

#Copia el script Perl EJERCICIO4 en el directorio CGI
COPY ejercicio4/ejercicio4.pl /usr/lib/cgi-bin/ejercicio4.pl
RUN chmod +x /usr/lib/cgi-bin/ejercicio4.pl

#Copia el script Perl EJERCICIO5 en el directorio CGI
COPY ejercicio5/ejercicio5.pl /usr/lib/cgi-bin/ejercicio5.pl
RUN chmod +x /usr/lib/cgi-bin/ejercicio5.pl

#Ejercicio5 html imagenes y css
COPY ./ejercicio5/formulario-ej5.html /var/www/html/
COPY ./ejercicio5/styles.css /var/www/html/css/
COPY ./ejercicio5/fips-logo.png /var/www/html/images/

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Configura MariaDB
RUN mysqld_safe --skip-networking & \
    sleep 5 && \
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
CMD mysqld_safe & apache2ctl -D FOREGROUND
