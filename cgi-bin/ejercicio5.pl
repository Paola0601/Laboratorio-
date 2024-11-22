#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener el año del formulario
my $year = $cgi->param('year') || '';

# Configuración de conexión a la base de datos
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
if (!$dbh) {
    print $cgi->header(-type => "text/html", -charset => "UTF-8");
    print "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";
    exit;
}

# Consulta SQL
my $sql = q{
    SELECT p.nombre AS pelicula, a.nombre AS actor
    FROM peliculas p
    JOIN casting c ON p.pelicula_id = c.pelicula_id
    JOIN actores a ON c.actor_id = a.actor_id
    WHERE p.year = ?
    ORDER BY p.nombre, a.nombre
};

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare($sql);
$sth->execute($year);

# Generar la tabla HTML con los resultados
my $resultados = "";
my $current_movie = "";
my @actors = ();

while (my $row = $sth->fetchrow_hashref) {
    if ($row->{pelicula} ne $current_movie) {
        if ($current_movie ne "") {
            $resultados .= "<tr><td>$current_movie</td><td>" . join(", ", @actors) . "</td></tr>\n";
        }
        $current_movie = $row->{pelicula};
        @actors = ($row->{actor});
    } else {
        push @actors, $row->{actor};
    }
}

if ($current_movie ne "") {
    $resultados .= "<tr><td>$current_movie</td><td>" . join(", ", @actors) . "</td></tr>\n";
}

# Cerrar conexión a la base de datos
$sth->finish();
$dbh->disconnect();

# Imprimir el HTML
print $cgi->header(-type => "text/html", -charset => "UTF-8");
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Películas del Año $year</title>
    <link rel="stylesheet" href="../estilos.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <nav>
                <a href="primer.pl">Actor de ID 5</a>
                <a href="segundo.pl">Actores con ID >= 8</a>
                <a href="tercero.pl">Películas con puntaje > 7 y votos > 5000</a>
                <a href="../index.html">Volver al índice</a>
            </nav>
        </div>
        <div class="main-content">
            <h1>Películas del Año $year</h1>
            <table>
                <thead>
                    <tr>
                        <th>Película</th>
                        <th>Actor(es)</th>
                    </tr>
                </thead>
                <tbody>
                    $resultados
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
HTML
