#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use CGI::Carp 'fatalsToBrowser';

# Crear el objeto CGI
my $q = CGI->new;
print $q->header('text/html; charset=UTF-8');

# Configuración de conexión
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

# Consulta para obtener actores con ID >= 8
my $sth = $dbh->prepare("SELECT actor_id, nombre FROM actores WHERE actor_id >= 8")
    or die "Error al preparar la consulta: $DBI::errstr\n";

$sth->execute() or die "Error al ejecutar la consulta: $DBI::errstr\n";

# Construir las filas de la tabla
my $tabla = "";
while (my @fila = $sth->fetchrow_array) {
    $tabla .= "<tr><td>" . join("</td><td>", @fila) . "</td></tr>";
}

# Validar si no hay resultados
if ($tabla eq "") {
    $tabla = "<tr><td colspan='2'>No se encontraron actores con ID mayor a 8.</td></tr>";
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;

# Generar el HTML
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../estilos.css">
    <link rel="icon" type="image/png" href="../imagenes/escudo-unsa.png">
    <title>Actores con ID >= 8</title>
</head>
<body>
    <div class="container">
        <div class="main-content">
            <h1>Actores con ID mayor a 8</h1>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
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
