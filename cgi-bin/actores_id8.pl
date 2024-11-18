use CGI qw(:standard);
use DBI;

print header();
print start_html("Actores con ID >= 8");
print "<table border='1'><tr><th>ID</th><th>Nombre</th></tr>";

my $dbh = DBI->connect("DBI:mysql:database=tu_base;host=localhost", "usuario", "contraseña", { RaiseError => 1 });
my $sth = $dbh->prepare("SELECT id, nombre FROM actores WHERE id >= 8");
$sth->execute();

while (my @row = $sth->fetchrow_array) {
    print "<tr><td>$row[0]</td><td>$row[1]</td></tr>";
}

print "</table>";
$sth->finish;
$dbh->disconnect;
print end_html();
