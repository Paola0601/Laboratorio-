#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use CGI::Carp 'fatalsToBrowser';

# Crear el objeto CGI
my $cgi = CGI->new;
print $cgi->header('text/html; charset=UTF-8');

# Obtener el año enviado por el formulario
my $year = $cgi->param('year');

# Validar que se haya proporcionado un año
if (!$year) {
    print "<h1>Error: No se proporcionó un año en el formulario.</h1>";
    exit;
}

# Configuración de conexión a la base de datos
my $database = "prueba";
my $hostname = "informacion";
my $port     = 3306;
my $user     = "paola";
my $password = "adamari";

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 })
    or die "Content-type: text/html\n\n<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";

# Consulta SQL para obtener películas y actores del año dado
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

# Generar el HTML de los resultados
my $output = "";
my $current_movie = "";
my @actors = ();

while (my $row = $sth->fetchrow_hashref) {
    if ($row->{pelicula} ne $current_movie) {
        # Si no es la primera película, imprimir los actores acumulados
        if ($current_movie ne "") {
            $output .= "<tr><td>$current_movie</td><td>" . join(", ", @actors) . "</td></tr>\n";
        }
        # Actualizar la película actual y reiniciar la lista de actores
        $current_movie = $row->{pelicula};
        @actors = ($row->{actor});
    } else {
        push @actors, $row->{actor};
    }
}

# Agregar la última película al resultado
if ($current_movie ne "") {
    $output .= "<tr><td>$current_movie</td><td>" . join(", ", @actors) . "</td></tr>\n";
}

# Si no hay resultados
if ($output eq "") {
    $output = "<tr><td colspan='2'>No se encontraron películas para el año $year.</td></tr>";
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;

# Generar la página HTML
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../estilos.css">
    <link rel="icon" type="image/png" href="../imagenes/escudo-unsa.png">
    <title>Películas del año $year</title>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <h1>Películas y Actores del Año</h1>
            <table>
                <thead>
                    <tr>
                        <th>Película</th>
                        <th>Actores</th>
                    </tr>
                </thead>
                <tbody>
                    $output
                </tbody>
            </table>
            <a class="volver" href="../index.html">Volver al índice</a>
        </div>
    </div>
</body>
</html>
HTML
