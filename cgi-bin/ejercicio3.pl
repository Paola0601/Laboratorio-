#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Crear el objeto CGI
my $q = CGI->new;
print $q->header('text/html; charset=UTF-8');

# Configuración de conexión
my $database = "prueba";
my $hostname = "mariadb2";
my $port     = 3306;
my $username = "paola";
my $password = "adamari";

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 });

# Ejecutar la consulta
my $sth = $dbh->prepare("SELECT id, nombre, año, votos, score FROM peliculas WHERE score > 7 AND vote > 5000");
$sth->execute();

# Construir las filas de la tabla
my $tabla = "";
while (my @fila = $sth->fetchrow_array) {
    $tabla .= "<tr><td>" . join("</td><td>", @fila) . "</td></tr>";
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;

# Generar el HTML
print <<HTML;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../estilos.css">
    <link rel="icon" type="image/png" href="../imagenes/logounsa.png">
    <title>Resultados</title>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <nav>
                <a href="ejercicio2.pl" class="nav-link">Actor de ID 5</a>
                <a href="ejercicio3.pl" class="nav-link">Actores con ID >= 8</a>
                <a href="ejercicio4.pl" class="nav-link">Películas con puntaje mayor a 7 y más de 5000 votos</a>
            </nav>
        </div>
        <div class="main-content">
            <h1>Películas con puntaje > 7 y votos > 5000</h1>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Año</th>
                        <th>Votos</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    $tabla
                </tbody>
            </table>
            <a class="volver" href="../index.html">Volver al índice</a>
        </div>
    </div>
</body>
</html>
HTML
