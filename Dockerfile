FROM perl:latest

# Instalar módulos Perl necesarios
RUN cpanm DBI DBD::mysql CGI

# Copiar los scripts CGI y configuraciones
COPY cgi-bin/ /usr/local/apache2/cgi-bin/
COPY html/ /usr/local/apache2/htdocs/

# Exponer el puerto
EXPOSE 80

# Comando para ejecutar Apache
CMD ["httpd-foreground"]
