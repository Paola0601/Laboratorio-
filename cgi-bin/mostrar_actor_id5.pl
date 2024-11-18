#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

print header(), start_html("Actor con ID 5");

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=prueba;host=127.0.0.1;port=3306";
my $dbh = DBI->connect($dsn, "root", "root_password", { RaiseError => 1 });

# Consulta
my $sth = $dbh->prepare("SELECT nombre FROM actores WHERE actor_id = 5");
$sth->execute();

# Mostrar resultado
if (my @row = $sth->fetchrow_array) {
    print "<p>Nombre del actor con ID 5: $row[0]</p>";
} else {
    print "<p>No se encontró el actor con ID 5</p>";
}

$sth->finish;
$dbh->disconnect;

print end_html();
