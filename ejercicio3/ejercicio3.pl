#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;

# Configuración de conexión
my $database = "prueba";
my $hostname = "mariadb2";
my $port     = 3306; 
my $username = "cgi_user";
my $password = "tu_password";

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 });

# Consulta SQL 
my $sql = q{
    SELECT actor_id, nombre
    FROM actores
    WHERE actor_id >= 8
};

my $sth = $dbh->prepare($sql);
$sth->execute();

# HTML con estilo
print "Content-type: text/html\n\n";
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actores con ID >= 8</title>
    <style>
        body {
            background-color: #000000;
            color: #ffffff;
            font-family: Arial, sans-serif;
        }
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
            background-color: #ffffff;
            color: #000000;
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
    <h1 style="text-align: center;">Actores con ID >= 8</h1>
    <table>
        <tr>
            <th>Actor ID</th>
            <th>Nombre</th>
        </tr>
HTML

# Imprimir filas
while (my $row = $sth->fetchrow_hashref) {
    print "<tr>";
    print "<td>$row->{actor_id}</td>";
    print "<td>$row->{nombre}</td>";
    print "</tr>";
}

# Cerrar tabla yhmtl
print <<HTML;
    </table>
</body>
</html>
HTML

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();