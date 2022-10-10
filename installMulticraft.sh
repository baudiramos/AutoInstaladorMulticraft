#!/bin/bash

# Funciones
instalarDependencias() {
	apt install apache2 -y
	apt install curl -y
	apt install mariadb-server -y
	apt install phpmyadmin -y
	apt install php-pdo -y
	apt install php-mysql -y
	apt install php-sqlite3 -y
	apt install php-curl -y
	apt install php-xml -y
	apt install php-gd -y
	
}



read -p "¿Deseas continuar con la instalación de multicraft? [S/n]" answer

case $answer in

  S)
    echo "Procediendo a instalar las dependencias"
	sleep 3
	instalarDependencias
    ;;

  N | n)
    echo "Saliendo del instalador"
	exit 0
    ;;

  *)
	echo "Saliendo del instalador"
	exit 0
	;;
esac

# Configurar MariaDB
echo 'Se va a configurar MariaDB y a instalar phpMyAdmin' 
sleep 4
read -p "¿Quieres cambiar la contraseña del usuario root? [S/N]" rootQuestion



case $rootQuestion in

  S)
    read -p "Escribe la contraseña de root [enter para ninguna]" rootPassword
	mysql -u "root" -Bse "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$rootPassword');"
	mysql -u "root" -p$rootPassword -Bse "USE mysql;"
	mysql -u "root" -p$rootPassword -D "mysql" -Bse "update mysql.user set plugin='mysql_native_password' where user='root';"
	mysql -u "root" -p$rootPassword -Bse "FLUSH PRIVILEGES;"
	echo "$cfg['Servers'][$i]['auth_type'] = 'cookie';" >> nano /etc/phpmyadmin/config.inc.php # Esto habilita el acceso por phpmyAdmin
    ;;
	
  "")
    echo "saltando paso..."
    ;;
esac

# Eliminara los usuarios anonimos
read -p "¿Eliminar los usuarios anonimos? [S/N]" anonymousUser

case $anonymousUser in

  S)
  	mysql -u "root" -p$rootPassword -Bse "DELETE FROM mysql.user WHERE User='';"
    ;;

  N)
    echo "saltando paso..."
    ;;

  *)
	echo "saltando paso..."
	;;
esac

# Deshabilitar acceso remoto
echo "$passwordUserRoot" 
read -p "¿Eliminar el acceso remoto al usuario root? [S/N]" anonymousUser

case $anonymousUser in

  S)
  	mysql -u "root" -p$rootPassword -Bse "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    ;;

  N)
    echo "saltando paso..."
    ;;

  *)
	echo "saltando paso..."
	;;
esac

# Eliminar bases de datos de pruebas y su acceso
read -p "¿Eliminar bases de datos de pruebas? [S/N]" testDatabase

case testDatabase in
  S)
    mysql -u "root" -p$rootPassword -Bse "DROP DATABASE test;"
	;;
  N)
	echo 'saltando paso...' 
	;;
esac

# Recargar los prvilegios de las tablas
read -p '¿Recargar los privilegios de las tablas? [S/N]' privilegesTable

case privilegesTable in
  S)
	mysql -u "root" -p$rootPassword -Bse "FLUSH PRIVILEGES;"
	;;
  N)
	echo 'saltando paso...' 
	;;
esac

apt install php libapache2-mod-php php-mysql -y
tabs 4
echo -e "<IfModule mod_dir.c>\n\tDirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.html\n</IfModule>" > test1.txt 
systemctl restart apache2
echo 'Maria DB y apache se ha configurado correctamente' 
sleep 2
# Proceder a instalar Multicraft
echo 'Se va ha crear la base de datos para el panel web'
sleep 3

# Creamos base de datos
mysql -u "root" -p$rootPassword -Bse "CREATE DATABASE multicraft_panel;"
mysql -u "root" -p$rootPassword -Bse "CREATE DATABASE multicraft_daemon;"

read -p "Por favor escriba la contraseña para el usuario [multicraft] de la bd" passwordBD
# Creamos el usuario para gestionar multicraft
mysql -u "root" -p$rootPassword -Bse "CREATE USER 'multicraft'@'localhost' IDENTIFIED BY '$passwordBD'"

# Le damos todos los privilegios al usuario creado sobre la base de datos de multicraft_panel y daemon
mysql -u "root" -p$rootPassword -Bse "GRANT ALL PRIVILEGES ON multicraft_panel.* TO 'multicraft'@'localhost';"
mysql -u "root" -p$rootPassword -Bse "GRANT ALL PRIVILEGES ON multicraft_daemon.* TO 'multicraft'@'localhost';"

# Aplicamos los cambios 
mysql -u "root" -p$passwordUserRoot -Bse "FLUSH PRIVILEGES;"

# Obtenemos multicraft
wget http://www.multicraft.org/download/linux64 -O multicraft.tar.gz

# Descomprimimos el archivo
tar xvzf multicraft.tar.gz

# Entramos al directorio
cd multicraft

# Ejecutamos el script
./setup.sh
