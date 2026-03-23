#!/bin/bash
docker exec -it hd360_mariadb sh -c 'mariadb-dump --all-databases --lock-tables --password=$MYSQL_ROOT_PASSWORD > /tmp/db_backup.sql'
docker container cp hd360_mariadb:/tmp/db_backup.sql ./db_backup.sql #Lo copia del container al host#