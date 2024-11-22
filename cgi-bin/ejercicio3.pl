#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Creamos el CGI
my $q = CGI->new;
print $q->header('text/html; charset=UTF-8');

# Configuración de conexión con la base de datos
my $database = "prueba";
my $hostname = "baseDeDatos"; # nombre del contenedor
my $port     = 3306;
my $user     = "paola";
my $password = "adamari";

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
}) or die "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";

# Consulta del ejercicio
my $score = 7;
my $votes = 5000;
my $query = "SELECT * FROM peliculas WHERE score > ? and vote > ?";
my $sth = $dbh->prepare($query);
$sth->execute($score, $votes);

# Ponemos los resultados en una variable para luego imprimirlos
my $resultados = "";
while (my @fila = $sth->fetchrow_array) {
    $resultados .= "<tr>\n";
    foreach my $dato (@fila) {
        $resultados .= "<td>$dato</td>\n";
    }
    $resultados .= "</tr>\n";
}

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();

# Imprimimos el HTML
print<<'HTML';
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
                <a href="tercero.pl" class="nav-link">Películas con puntaje mayor a 7 y más de 5000 votos</a>
            </nav>
        </div>
        <div class="main-content">
            <header>
                <h1>Resultados de la Consulta</h1>
            </header>
            <main>
                <h3>Películas con puntaje mayor a 7 y más de 5000 votos</h3>
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
HTML

print $resultados;

print<<'HTML';
                    </tbody>
                </table>
                <a class="volver" href="../index.html">Volver al índice</a>
            </main>
        </div>
    </div>
</body>
</html>
HTML
