CREATE DATABASE IF NOT EXISTS prueba;
USE prueba;

CREATE TABLE IF NOT EXISTS actores (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS peliculas (
    pelicula_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    year INT,
    vote INT,
    score DECIMAL(3,1)
);

CREATE TABLE IF NOT EXISTS casting (
    casting_id INT PRIMARY KEY AUTO_INCREMENT,
    pelicula_id INT,
    actor_id INT,
    papel VARCHAR(100),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(pelicula_id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES actores(actor_id) ON DELETE CASCADE
);

INSERT INTO actores (nombre) VALUES ('Robert Downey Jr.', 'Scarlett Johansson', 'Chris Hemsworth');
INSERT INTO peliculas (nombre, year, vote, score) VALUES 
    ('Avengers: Endgame', 2019, 8500, 8.4), 
    ('Iron Man', 2008, 4000, 7.9), 
    ('Thor', 2011, 3200, 7.0);

INSERT INTO casting (pelicula_id, actor_id, papel) VALUES 
    (1, 1, 'Iron Man'), 
    (1, 2, 'Black Widow'), 
    (1, 3, 'Thor'), 
    (2, 1, 'Iron Man'), 
    (3, 3, 'Thor');
