#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use DBI;

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=prueba;host=127.0.0.1;port=3306";
my $user = "root";
my $pass = "root_password";

my $dbh = DBI->connect($dsn, $user, $pass, { RaiseError => 1, AutoCommit => 1 });

# Operación seleccionada desde el formulario
my $operacion = param('operacion');
my $tabla = param('tabla');

# Ejecutar la operación seleccionada
if ($operacion eq 'agregar') {
    if ($tabla eq 'actores') {
        my $nombre = param('nombre');
        $dbh->do("INSERT INTO actores (nombre) VALUES (?)", undef, $nombre);
        print redirect('index.html');
    }
    # Aquí puedes agregar más operaciones para películas y casting
} elsif ($operacion eq 'modificar') {
    if ($tabla eq 'actores') {
        my $actor_id = param('actor_id');
        my $nuevo_nombre = param('nombre');
        $dbh->do("UPDATE actores SET nombre = ? WHERE actor_id = ?", undef, $nuevo_nombre, $actor_id);
        print redirect('index.html');
    }
} elsif ($operacion eq 'eliminar') {
    if ($tabla eq 'actores') {
        my $actor_id = param('actor_id');
        $dbh->do("DELETE FROM actores WHERE actor_id = ?", undef, $actor_id);
        print redirect('index.html');
    }
}

$dbh->disconnect;
