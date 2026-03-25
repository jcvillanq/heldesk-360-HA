Para ejecutarlo usaremos el siguiente comando en el contenedor:		         chmod +x generar_usuarios.sh

										./generar_usuarios.sh > usuarios.ldif

---------------------------------------------------------
#!/bin/bash

BASE_DN="dc=infraticket,dc=local"

for i in $(seq 1 50); do
cat <<EOF
dn: uid=user$i,ou=usuarios,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: Usuario $i
sn: Usuario$i
givenName: Usuario
uid: user$i
uidNumber: $((1000 + i))
gidNumber: 1000
homeDirectory: /home/user$i
loginShell: /bin/bash
mail: user$i@infraticket.local
userPassword: 123456

EOF
done

----------------------------------------------------------------

#!/bin/bash

BASE_DN="dc=infraticket,dc=local"

for i in $(seq 1 50); do
cat <<EOF
dn: uid=user$i,ou=usuarios,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: Usuario $i
sn: Usuario$i
givenName: Usuario
uid: user$i
uidNumber: $((1000 + i))
gidNumber: 1000
homeDirectory: /home/user$i
loginShell: /bin/bash
mail: user$i@infraticket.local
userPassword: 123456

EOF
done




-------------------------------------------------------------
										IMPORTAR USUARIOS A OPENLDAP
docker cp usuarios.ldif openldap:/usuarios.ldif

docker exec -it openldap ldapadd -x \
-D "cn=admin,dc=infraticket,dc=local" \
-w adminpass \
-f /usuarios.ldif




----------------------------------------------------------------------------------------------------

#!/bin/bash

BASE_DN="dc=infraticket,dc=local"

# Departamentos
declare -A DEPARTAMENTOS=( ["IT"]=1000 ["Soporte"]=2000 ["Administracion"]=3000 )

for dep in "${!DEPARTAMENTOS[@]}"; do
  OU_DN="ou=$dep,$BASE_DN"

  # Crear OU en LDIF
  echo "dn: ou=$dep,$BASE_DN"
  echo "objectClass: organizationalUnit"
  echo "ou: $dep"
  echo ""

  # Crear 15-20 usuarios por departamento
  for i in $(seq 1 15); do
    UID="${dep,,}$i"  # minúsculas
    echo "dn: uid=$UID,ou=$dep,$BASE_DN"
    echo "objectClass: inetOrgPerson"
    echo "objectClass: posixAccount"
    echo "objectClass: top"
    echo "cn: Usuario $UID"
    echo "sn: $UID"
    echo "givenName: $dep"
    echo "uid: $UID"
    echo "uidNumber: $((DEPARTAMENTOS[$dep]+i))"
    echo "gidNumber: ${DEPARTAMENTOS[$dep]}"
    echo "homeDirectory: /home/$UID"
    echo "loginShell: /bin/bash"
    echo "mail: $UID@infraticket.local"
    echo "userPassword: 123456"
    echo ""
  done

  # Crear grupo para departamento
  echo "dn: cn=${dep}_group,ou=grupos,$BASE_DN"
  echo "objectClass: posixGroup"
  echo "cn: ${dep}_group"
  echo "gidNumber: ${DEPARTAMENTOS[$dep]}"
  for i in $(seq 1 15); do
    echo "memberUid: ${dep,,}$i"
  done
  echo ""
done

Esto generará usuarios en 3 departamentos: IT, Soporte y Administración, con sus grupos asociados.































