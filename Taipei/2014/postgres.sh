#/bin/bash
service postgresql-9.2 initdb
sed -ie 's/max_connections = 100/max_connections = 1000/' /var/lib/pgsql/9.2/data/postgresql.conf
service postgresql-9.2 start
chkconfig postgresql-9.2 on

mv /var/lib/pgsql/9.2/data/pg_hba.conf{,_ori}
cat >/var/lib/pgsql/9.2/data/pg_hba.conf <<EOF
# TYPE  DATABASE    USER        CIDR-ADDRESS          METHOD

# "local" is for Unix domain socket connections only
local   all         all                               trust
# IPv4 local connections:
host    all         all         127.0.0.1/32          trust
# IPv6 local connections:
host    all         all         ::1/128               trust
EOF
service postgresql-9.2 restart
createdb -U postgres chimera
createuser -U postgres --no-superuser --no-createrole --createdb chimera
psql -U chimera chimera -f /usr/share/dcache/chimera/sql/create.sql
createlang -U postgres plpgsql chimera
psql -U chimera chimera -f /usr/share/dcache/chimera/sql/pgsql-procedures.sql
createuser -U postgres --no-superuser --no-createrole --createdb srmdcache
createdb -U srmdcache dcache
