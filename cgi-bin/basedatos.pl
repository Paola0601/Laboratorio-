#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI::Carp 'fatalsToBrowser';

# Configuración de conexión
my $database = "prueba";
my $hostname = "localhost"; # O el nombre del contenedor MariaDB
my $port = 3306;
my $user = "root";
my $password = "tu_contraseña_segura";

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, {
    RaiseError => 1,
    PrintError => 0,
    mysql_enable_utf8 => 1,
});

# Prueba de conexión
if ($dbh) {
    print "Content-type: text/html\n\n";
    print "<html><body><h1>Conexión exitosa a MariaDB</h1></body></html>";
} else {
    die "Error al conectar a la base de datos: $DBI::errstr\n";
}

# Cerrar conexión
$dbh->disconnect();
