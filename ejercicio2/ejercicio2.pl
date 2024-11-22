#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "prueba";
my $hostname = "mariadb2";
my $port     = 3306; 
my $username = "paola";
my $password = "soyunarata";

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 });

# Consulta ID 5 
my $sql = q{
    SELECT nombre
    FROM actores
    WHERE actor_id = 5
};

my $sth = $dbh->prepare($sql);
$sth->execute();

# Obtener el resultado
my $actor = $sth->fetchrow_array;

# HTML
print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actor ID-5</title>
</head>
<body>
    <h1>ES: </h1>
HTML

if ($actor) {
    print "<p>El nombre del actor con ID 5 es: <em>$actor</em></p>\n";
} else {
    print "<p>No se encontró ningún actor con ID 5.</p>\n";
}

print <<HTML;
</body>
</html>
HTML

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();