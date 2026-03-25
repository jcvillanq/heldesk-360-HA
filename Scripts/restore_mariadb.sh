#!/bin/bash
gpg db_backup.gpg -o db_backup.sql --passphrase contraseña_de_cifrado #descifra la base de datos#
docker container cp ./db_backup.sql hd360_mariadb:/tmp/db_backup.sql  #Lo copia del host al container#
docker exec -it hd360_mariadb sh -c 'mariadb --password=$MYSQL_ROOT_PASSWORD < /tmp/db_backup.sql'