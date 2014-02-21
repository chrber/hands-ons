#/bin/bash
rpm -Uhv http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-sl92-9.2-8.noarch.rpm
wget http://www.dcache.org/downloads/1.9/repo/2.6/dcache-2.6.21-1.noarch.rpm -O ~/dcache-2.6.21-1.noarch.rpm 

yum install postgresql92-server.x86_64 -y
yum install java-1.7.0-openjdk.x86_64 -y
yum install nfs-utils -y

echo "RPCBIND_ARGS=\"-i\"" > /etc/sysconfig/rpcbind

service rpcbind restart

echo "alias nfs-layouttype4-1 nfs_layout_nfsv41_files" > /etc/modprobe.d/dist-nfsv41.conf

modprobe nfs_layout_nfsv41_files

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

iptables -F
sed -ie 's/#Domain = local.domain.edu/Domain = taipei-domain/' /etc/idmapd.conf
/etc/init.d/rpcidmapd restart
