use CGI qw(:standard);
use DBI;

print header();
print start_html("Películas con puntaje > 7 y votos > 5000");
print "<table border='1'><tr><th>ID</th><th>Título</th><th>Puntaje</th><th>Votos</th></tr>";

my $dbh = DBI->connect("DBI:mysql:database=tu_base;host=localhost", "usuario", "contraseña", { RaiseError => 1 });
my $sth = $dbh->prepare("SELECT id, titulo, puntaje, votos FROM peliculas WHERE puntaje > 7 AND votos > 5000");
$sth->execute();

while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td><td>$row[2]</td><td>$row[3]</td></tr>";
}

print "</table>";
$sth->finish;
$dbh->disconnect;
print end_html();
