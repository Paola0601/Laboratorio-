use CGI qw(:standard);
use DBI;

my $anio = param('anio');

print header();
print start_html("Películas del año $anio");

my $dbh = DBI->connect("DBI:mysql:database=tu_base;host=localhost", "usuario", "contraseña", { RaiseError => 1 });
my $sth = $dbh->prepare("SELECT p.titulo, a.nombre FROM peliculas p JOIN casting c ON p.id = c.pelicula_id JOIN actores a ON c.actor_id = a.id WHERE p.anio = ?");
$sth->execute($anio);

print "<table border='1'><tr><th>Película</th><th>Actor</th></tr>";
while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td></tr>";
}

print "</table>";
$sth->finish;
$dbh->disconnect;
print end_html();
