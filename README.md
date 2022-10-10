# AutoInstaladorMulticraft
Este es un script que te instala multicraft con sus dependencias

## Este script solo tiene soporte para Debian 9

Una vez descargado, accedemos como root usando:

> sudo su

Una vez logeado como root le damos permisos de ejecución al script

> chmod +x ~/installMulticraft.sh

Una vez tenga los permisos, lo ejecutamos

> ./installMulticraft.sh

Estos son las dependencias que se van a instalar :

* apache2
* curl
* mariadb-server
* phpmyadmin
* php-pdo
* php-mysql
* php-sqlite3
* php-curl
* php-xml
* php-gd

# Instalación phpmyadmin
Cuándo te pregunte por crear una base de datos en la instalación de phpmyadmin selecciona No.

Cúando te pregunte si quieres cambiar la contraseña del usuario root elige la opción S, para que la base de datos de multicraft se instale correctamente.

## Pronto haré el script para desinstalar multicraft
