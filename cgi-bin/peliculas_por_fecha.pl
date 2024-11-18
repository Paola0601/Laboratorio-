#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

my $anio = param('anio');

print header(), start_html("Películas del año $anio");

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=prueba;host=127.0.0.1;port=3306";
my $dbh = DBI->connect($dsn, "root", "root_password", { RaiseError => 1 });

# Consulta
my $sth = $dbh->prepare("SELECT p.nombre, a.nombre AS actor FROM peliculas p 
    JOIN casting c ON p.pelicula_id = c.pelicula_id 
    JOIN actores a ON c.actor_id = a.actor_id 
    WHERE p.year = ?");
$sth->execute($anio);

# Mostrar resultados
print "<table border='1'><tr><th>Película</th><th>Actor</th></tr>";
while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td></tr>";
}
print "</table>";

$sth->finish;
$dbh->disconnect;

print end_html();
