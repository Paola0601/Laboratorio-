#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

print header(), start_html("Actores con ID >= 8");

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=prueba;host=127.0.0.1;port=3306";
my $dbh = DBI->connect($dsn, "root", "root_password", { RaiseError => 1 });

# Consulta
my $sth = $dbh->prepare("SELECT actor_id, nombre FROM actores WHERE actor_id >= 8");
$sth->execute();

# Mostrar resultados
print "<table border='1'><tr><th>ID</th><th>Nombre</th></tr>";
while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td></tr>";
}
print "</table>";

$sth->finish;
$dbh->disconnect;

print end_html();

