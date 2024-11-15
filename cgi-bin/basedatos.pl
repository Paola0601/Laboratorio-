#!/usr/bin/perl

use strict;
use warnings;
use DBI;

# Encabezados para la salida web
print "Content-type: text/html\n\n";

# Datos de conexión
my $dsn = "DBI:mysql:database=prueba;host=localhost";
my $usuario = "root";
my $password = "root_password";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $usuario, $password, {'RaiseError' => 1, 'PrintError' => 0})
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Realizar una consulta a la base de datos
my $sth = $dbh->prepare("SELECT * FROM actores");
$sth->execute();

# Mostrar los resultados en formato HTML
print "<h1>Actores:</h1><ul>\n";
while (my @row = $sth->fetchrow_array) {
    print "<li>ID: $row[0], Nombre: $row[1]</li>\n";
}
print "</ul>\n";

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;
