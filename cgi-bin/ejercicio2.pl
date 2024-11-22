#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use CGI::Carp 'fatalsToBrowser';


my $cgi = CGI->new;
print $cgi->header('text/html; charset=UTF-8');

# Configuración de conexión
my $database = "prueba";
my $hostname = "informacion";
my $port     = 3306;
my $user = "paola";
my $password = "adamari";



# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 })
    or die "Content-type: text/html\n\n<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";

# Consulta ID 5
my $sql = q{
    SELECT nombre
    FROM actores
    WHERE actor_id = 5
};

my $sth = $dbh->prepare($sql) or die "Error en la preparación de la consulta: $DBI::errstr\n";
$sth->execute() or die "Error al ejecutar la consulta: $DBI::errstr\n";


# Obtener el resultado
my $actor = $sth->fetchrow_array;

print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../estilos.css">
    <link rel="icon" type="image/png" href="../imagenes/escudo-unsa.png">
    <title>Actor ID-5</title>
</head>
<body>
    <header>
        <h1>¡Bienvenido a la base de datos!</h1>
    </header>
    <div class="container">
        <div class="menu">
            <nav>
                <a href="./ejercicio2.pl" class="nav-link">Actor de ID 5</a>
                <a href="./ejercicio3.pl" class="nav-link">Actores con ID >= 8</a>
                <a href="./ejercicio4.pl" class="nav-link">Películas con puntaje mayor a 7 y más de 5000 votos</a>
            </nav>
        </div>
        <div class="main-content">
            <h2>Resultados de la consulta</h2>
HTML

if ($actor) {

    print <<TABLE;
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre del Actor</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>5</td>
                        <td>$actor</td>
                    </tr>
                </tbody>
            </table>
TABLE
} else {
    print "<p>No se encontró ningún actor con ID 5.</p>\n";
}

print <<HTML;
            <a href="../index.html" class="volver">Volver al índice</a>
        </div>
    </div>
</body>
</html>
HTML

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();
