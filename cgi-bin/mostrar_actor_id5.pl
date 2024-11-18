use CGI qw(:standard);
use DBI;

print header();
print start_html("Actor ID 5");

my $dbh = DBI->connect("DBI:mysql:database=tu_base;host=localhost", "usuario", "contraseña", { RaiseError => 1 });
my $sth = $dbh->prepare("SELECT nombre FROM actores WHERE id = 5");
$sth->execute();

while (my @row = $sth->fetchrow_array) {
    print "<p>Nombre del actor: $row[0]</p>";
}

$sth->finish;
$dbh->disconnect;
print end_html();
