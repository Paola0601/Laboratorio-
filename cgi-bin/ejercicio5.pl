#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener el año del formulario
my $year = $cgi->param('year') || '';

# Configuración de conexión a la base de datos
my $database = "prueba";
my $hostname = "mariadb2";
my $port     = 3306;
my $username = "cgi_user";  
my $password = "tu_password";  

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $username, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

# Validar conexión
if (!$dbh) {
    print $cgi->header(-type => "text/html", -charset => "UTF-8");
    print "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";
    exit;
}

# Consulta de las películas y actores del año dado, agrupados por película
my $sql = q{
    SELECT p.nombre AS pelicula, a.nombre AS actor
    FROM peliculas p
    JOIN casting c ON p.pelicula_id = c.pelicula_id
    JOIN actores a ON c.actor_id = a.actor_id
    WHERE p.year = ?
    ORDER BY p.nombre, a.nombre
};

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare($sql);
$sth->execute($year);

# CREAMOS UNA VARIABLE PARA ALMACENAR EL HTML DE LOS RESULTADOS
my $output = "";
my $current_movie = "";
my @actors = ();

# ITERAMOS SOBRE LOS RESULTADOS OBTENIDOS DE LA BASE DE DATOS
while (my $row = $sth->fetchrow_hashref) {
    # SI CAMBIA LA PELÍCULA, IMPRIMIMOS LA PELÍCULA Y LOS ACTORES ASOCIADOS
    if ($row->{pelicula} ne $current_movie) {
        # SI NO ES LA PRIMERA VEZ, IMPRIMIMOS LOS ACTORES ANTERIORES
        if ($current_movie ne "") {
            # EVITAMOS CREADOS Celdas VACÍAS EN LA TABLA
            $output .= "<tr><td>$current_movie</td><td>" . join(", ", @actors) . "</td></tr>\n";
        }

        # ACTUALIZAMOS LA PELÍCULA Y REINICIAMOS LA LISTA DE ACTORES
        $current_movie = $row->{pelicula};
        @actors = ($row->{actor});  # AGREGAMOS EL PRIMER ACTOR
    } else {
        # SI LA PELÍCULA ES LA MISMA, AGREGAMOS EL ACTOR A LA LISTA
        push @actors, $row->{actor};
    }
}

# IMPRIMIMOS LOS RESULTADOS DE LA ÚLTIMA PELÍCULA (QUE QUEDÓ FUERA DEL BUCLE)
if ($current_movie ne "") {
    $output .= "<tr><td>$current_movie</td><td>" . join(", ", @actors) . "</td></tr>\n";
}

print $cgi->header(-type => "text/html", -charset => "UTF-8");
print "<table><tr><th>Película</th><th>Actor(s)</th></tr>$output</table>";

# Cerrar la conex
$sth->finish();
$dbh->disconnect();