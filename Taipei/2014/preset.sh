#/bin/bash
rpm -Uhv http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-sl92-9.2-8.noarch.rpm
wget http://www.dcache.org/downloads/1.9/repo/2.5/dcache-2.5.0-1.noarch.rpm -O dcache-2.5.0-1.noarch.rpm

yum install postgresql92-server.x86_64 -y
yum install java-1.7.0-openjdk.x86_64 -y
yum install nfs-utils -y

echo "RPCBIND_ARGS=\"-i\"" > /etc/sysconfig/rpcbind

service rpcbind restart

echo "alias nfs-layouttype4-1 nfs_layout_nfsv41_files" > /etc/modprobe.d/dist-nfsv41.conf

modprobe nfs_layout_nfsv41_files

echo "#/bin/bash
service postgresql-9.2 initdb
sed -ie 's/max_connections = 100/max_connections = 1000/' /var/lib/pgsql/9.2/data/postgresql.conf
service postgresql-9.2 start
chkconfig postgresql-9.2 on

mv /var/lib/pgsql/9.2/data/pg_hba.conf{,_ori}
cat >/var/lib/pgsql/9.2/data/pg_hba.conf <<EOF
# TYPE DATABASE USER CIDR-ADDRESS METHOD

# \"local\" is for Unix domain socket connections only
local all all trust
# IPv4 local connections:
host all all 127.0.0.1/32 trust
# IPv6 local connections:
host all all ::1/128 trust
EOF
service postgresql-9.2 restart
createdb -U postgres chimera
createuser -U postgres --no-superuser --no-createrole --createdb chimera
psql -U chimera chimera -f /usr/share/dcache/chimera/sql/create.sql
createlang -U postgres plpgsql chimera
psql -U chimera chimera -f /usr/share/dcache/chimera/sql/pgsql-procedures.sql
createuser -U postgres --no-superuser --no-createrole --createdb srmdcache
createdb -U srmdcache dcache" > configurepgsql.sh;
chmod +x configurepgsql.sh;

echo "for index in \`seq 1 100\`;
do
dd if=/dev/urandom of=/nfs4/bigFile$index bs=1M count=2
echo Createing file: $index;
done" > create100_Big_Files.sh;

chmod +x create100_Big_Files.sh

echo "#/bin/bash
no_of_files=120
counter=101
while [[ $counter -le \$no_of_files ]]
  do
   dd bs=256 count=\$RANDOM if=/dev/urandom of=random-file.\$counter
   cp   random-file.\$counter /nfs4/random-file.\$counter
   rm  -f random-file.\$counter
   let \"counter += 1\"
  done

no_of_files=225
counter=201
while [[ \$counter -le \$no_of_files ]]
  do
   dd bs=256 count=\$((RANDOM%200+1)) if=/dev/urandom of=random-file.\$counter
   cp   random-file.\$counter /nfs4/random-file.\$counter
   rm  -f random-file.\$counter
   let \"counter += 1\"
  done

no_of_files=325
counter=301
while [[ \$counter -le \$no_of_files ]]
  do
   dd bs=256 count=\$((RANDOM%20+1)) if=/dev/urandom of=random-file.\$counter
   cp   random-file.\$counter /nfs4/random-file.\$counter
   rm  -f random-file.\$counter
   let \"counter += 1\"
  done" > gen_rand_files.sh

chmod +x gen_rand_files.sh

wget http://svn.dcache.org/downloads/hands-on/ca_dCacheORG-2.1-1.noarch.rpm -O ca_dCacheORG-2.1-1.noarch.rpm

yum localinstall ca_dCacheORG-2.1-1.noarch.rpm -y

iptables -F
sed -ie 's/#Domain = local.domain.edu/Domain = taipei-domain/' /etc/idmapd.conf
/etc/init.d/rpcidmapd restart
