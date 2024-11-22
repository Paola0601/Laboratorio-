#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

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

# Validar conexión
if ($dbh) {
    print "Content-type: text/html\n\n";  # Declara la página web
} else {
    die "Content-type: text/html\n\nError al conectar a la base de datos: $DBI::errstr\n";
}

# Consulta SQL 
my $sql = q{
    SELECT pelicula_id, nombre, year, vote, score
    FROM peliculas
    WHERE score > 7 AND vote > 5000
};

my $sth = $dbh->prepare($sql);
$sth->execute();

# Generar el HTML con navegación y tabla
print <<'HTML';
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Películas con Puntaje Mayor a 7 y Más de 5000 Votos</title>
    <link rel="stylesheet" type="text/css" href="../estilos.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <nav>
                <a href="ejercicio2.pl">Actor de ID 5</a>
                <a href="ejercicio3.pl">Actores con ID >= 8</a>
                <a href="ejercicio4.pl">Películas con puntaje mayor a 7 y más de 5000 votos</a>
                <a href="../index.html">Volver al índice</a>
            </nav>
        </div>
        <div class="main-content">
            <h1>Películas con Puntaje Mayor a 7 y Más de 5000 Votos</h1>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Año</th>
                        <th>Votos</th>
                        <th>Puntaje</th>
                    </tr>
                </thead>
                <tbody>
HTML

# Imprimir las filas de la tabla
while (my $row = $sth->fetchrow_hashref) {
    print "<tr>";
    print "<td>$row->{pelicula_id}</td>";
    print "<td>$row->{nombre}</td>";
    print "<td>$row->{year}</td>";
    print "<td>$row->{vote}</td>";
    print "<td>$row->{score}</td>";
    print "</tr>";
}

# Cerrar el contenido HTML
print <<'HTML';
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
HTML

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
