#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

print header(), start_html("Películas con puntaje > 7 y votos > 5000");

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=prueba;host=127.0.0.1;port=3306";
my $dbh = DBI->connect($dsn, "root", "root_password", { RaiseError => 1 });

# Consulta
my $sth = $dbh->prepare("SELECT nombre, year, score, vote FROM peliculas WHERE score > 7 AND vote > 5000");
$sth->execute();

# Mostrar resultados
print "<table border='1'><tr><th>Nombre</th><th>Año</th><th>Puntaje</th><th>Votos</th></tr>";
while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td><td>$row[2]</td><td>$row[3]</td></tr>";
}
print "</table>";

$sth->finish;
$dbh->disconnect;

print end_html();
