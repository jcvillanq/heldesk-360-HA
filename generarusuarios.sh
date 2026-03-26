#!/bin/bash

LDAP_ADMIN="cn=admin,dc=infraticket,dc=local"
LDAP_PASS="LdapLocal789!"
LDAP_HOST="ldap://infraticket_openldap"

for i in {1..10}
do

cat <<EOF > user$i.ldif
dn: uid=user$i,ou=people,dc=infraticket,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: User $i
sn: User$i
uid: user$i
uidNumber: 100$i
gidNumber: 1000
homeDirectory: /home/user$i
loginShell: /bin/bash
mail: user$i@infraticket.local
userPassword: password$i
EOF

ldapadd -x -H $LDAP_HOST -D $LDAP_ADMIN -w $LDAP_PASS -f user$i.ldif

done