use DBI;
# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=tu_base;host=localhost", "usuario", "contraseña", { RaiseError => 1 });

# Agregar registro
my $sth = $dbh->prepare("INSERT INTO actores (nombre) VALUES (?)");
$sth->execute("Nuevo Actor");

# Modificar registro
$sth = $dbh->prepare("UPDATE actores SET nombre = ? WHERE id = ?");
$sth->execute("Actor Modificado", 5);

# Borrar registro
$sth = $dbh->prepare("DELETE FROM actores WHERE id = ?");
$sth->execute(10);

$sth->finish;
$dbh->disconnect;
