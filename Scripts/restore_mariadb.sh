#!/bin/bash
docker container cp ./db_backup.sql hd360_mariadb:/tmp/db_backup.sql  #Lo copia del host al container#
docker exec -it hd360_mariadb sh -c 'mariadb --password=$MYSQL_ROOT_PASSWORD < /tmp/db_backup.sql'