CREATE DATABASE IF NOT EXISTS prueba;
USE prueba;

CREATE TABLE actores (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);

CREATE TABLE peliculas (
    pelicula_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    year INT,
    vote INT,
    score DECIMAL(3,1)
);

CREATE TABLE casting (
    casting_id INT PRIMARY KEY AUTO_INCREMENT,
    pelicula_id INT,
    actor_id INT,
    papel VARCHAR(100),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(pelicula_id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES actores(actor_id) ON DELETE CASCADE
);


