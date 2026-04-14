#!/bin/bash
echo "===================================="
echo "HD360 - Script LDAP iniciad0"
echo "===================================="
CONTAINER="hd360_openldap"
LDAP_ADMIN="cn=admin,dc=infraticket,dc=local"
LDAP_PASS="LdapLocal789!"
BASE_DN="dc=infraticket,dc=local"

echo "Verificando contenedor LDAP..."

docker ps | grep $CONTAINER

if [ $? -ne 0 ]; then
    echo "El contenedor hd360_openldap no está en ejecución"
    exit 1
fi

echo "Contenedor encontrado"
echo ""

echo "Creando estructura base LDAP..."

docker exec -i $CONTAINER ldapadd -x -D "$LDAP_ADMIN" -w "$LDAP_PASS" <<EOF

dn: ou=people,$BASE_DN
objectClass: organizationalUnit
ou: people

dn: ou=groups,$BASE_DN
objectClass: organizationalUnit
ou: groups

dn: cn=admins,ou=groups,$BASE_DN
objectClass: groupOfNames
cn: admins
member: cn=admin,$BASE_DN

dn: cn=soporte,ou=groups,$BASE_DN
objectClass: groupOfNames
cn: soporte
member: cn=admin,$BASE_DN

dn: cn=tecnicos,ou=groups,$BASE_DN
objectClass: groupOfNames
cn: tecnicos
member: cn=admin,$BASE_DN

dn: cn=usuarios,ou=groups,$BASE_DN
objectClass: groupOfNames
cn: usuarios
member: cn=admin,$BASE_DN

EOF

echo "OU y grupos creados"
echo ""

echo "Creando usuarios..."

users=(
"Juan Garcia"
"Maria Lopez"
"Carlos Sanchez"
"Laura Martinez"
"David Fernandez"
"Ana Rodriguez"
"Javier Perez"
"Marta Gomez"
"Daniel Ruiz"
"Sara Torres"
"Pablo Navarro"
"Elena Romero"
"Sergio Molina"
"Lucia Castro"
"Miguel Ortiz"
"Carmen Delgado"
"Adrian Moreno"
"Patricia Vega"
"Ruben Herrera"
"Beatriz Flores"
"Alberto Ramos"
"Cristina Cabrera"
"Hector Dominguez"
"Nuria Santos"
"Ivan Gil"
)

for user in "${users[@]}"
do
    name=$(echo $user | cut -d ' ' -f1)
    surname=$(echo $user | cut -d ' ' -f2)
    uid=$(echo "$name.$surname" | tr '[:upper:]' '[:lower:]')

    docker exec -i $CONTAINER ldapadd -x -D "$LDAP_ADMIN" -w "$LDAP_PASS" <<EOF
dn: uid=$uid,ou=people,$BASE_DN
objectClass: inetOrgPerson
objectClass: top
cn: $user
sn: $surname
uid: $uid
mail: $uid@infraticket.local
userPassword: password
EOF

    echo "✔ Usuario creado: $uid"

done

echo ""
echo "===================================="
echo "LDAP configurado correctamente"
echo "25 usuarios creados"
echo "===================================="