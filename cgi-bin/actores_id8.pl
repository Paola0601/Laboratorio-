#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;
use CGI::Carp 'fatalsToBrowser';


print header(), start_html("Actores con ID >= 8");

# Configuración de conexión
my $database = "prueba";
my $hostname = "127.0.0.1";
my $port     = 3306;
my $user     = "root";
my $password = "mi_contrasena_segura";  # Si configuraste una contraseña

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

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
# Cerrar la conexión
$dbh->disconnect();
