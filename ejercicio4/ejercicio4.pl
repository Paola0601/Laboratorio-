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
    print "Content-type: text/html\n\n";  # Declara la pagina web
    print "<h1>Conexión exitosa a la base de datos '$database'.</h1>\n";
} else {
    die "Content-type: text/html\n\nError al conectar a la base de datos: $DBI::errstr\n";
}

# Consulta SQL 
my $sql = q{
    SELECT pelicula_id, nombre, year, vote, score
    FROM peliculas
    WHERE score > 7 AND vote > 5000
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
    <title>Películas con Puntaje Mayor a 7 y Más de 5000 Votos</title>
    <style>
        body {
            background-color: black;
            color: white;
        }

        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
            background-color: black; 
        }

        th, td {
            border: 1px solid white; 
            padding: 8px;
            text-align: left;
            color: white; 
        }

        th {
            background-color: #333;
        }

        tr {
            background-color: black; 
        }

    </style>
</head>
<body>
    <h1 style="text-align: center;">Películas con Puntaje Mayor a 7 y Más de 5000 Votos</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Año</th>
            <th>Votos</th>
            <th>Puntaje</th>
        </tr>
HTML

# Imprimir la tabla por filas
while (my $row = $sth->fetchrow_hashref) {
    print "<tr>";
    print "<td>$row->{pelicula_id}</td>";
    print "<td>$row->{nombre}</td>";
    print "<td>$row->{year}</td>";
    print "<td>$row->{vote}</td>";
    print "<td>$row->{score}</td>";
    print "</tr>";
}

# Cerrar tabla y html
print <<'HTML';
    </table>
</body>
</html>
HTML

# Cerrar la conexión
$sth->finish();
$dbh->disconnect();