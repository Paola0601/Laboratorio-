#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "prueba";
my $hostname = "mariadb2";              
my $port     = 3306;  # Usa 3306 o 3307 
my $username = "cgi_user";  # Nombre de usuario actualizado
my $password = "tu_password";  # Contraseña actualizada

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

# Validar conexión
if ($dbh) {
    print "Content-type: text/html\n\n";  # Cambiado a 'text/html' para generar una página web
    print "<h1>Conexión exitosa a la base de datos '$database'.</h1>\n";
} else {
    die "Content-type: text/html\n\nError al conectar a la base de datos: $DBI::errstr\n";
}

# Consulta SQL para obtener los datos del casting
my $sql = q{
    SELECT casting.casting_id, peliculas.nombre AS pelicula, actores.nombre AS actor, casting.papel
    FROM casting
    JOIN peliculas ON casting.pelicula_id = peliculas.pelicula_id
    JOIN actores ON casting.actor_id = actores.actor_id
};

my $sth = $dbh->prepare($sql);
$sth->execute();

# Generar la tabla HTML con los resultados
print <<'HTML';
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados del Casting</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center;">Resultados del Casting</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Película</th>
            <th>Actor</th>
            <th>Papel</th>
        </tr>
HTML

# Imprimir las filas de la tabla
while (my $row = $sth->fetchrow_hashref) {
    print "<tr>";
    print "<td>$row->{casting_id}</td>";
    print "<td>$row->{pelicula}</td>";
    print "<td>$row->{actor}</td>";
    print "<td>$row->{papel}</td>";
    print "</tr>";
}

# Cerrar la tabla y el cuerpo del HTML
print <<'HTML';
    </table>
</body>
</html>
HTML

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();