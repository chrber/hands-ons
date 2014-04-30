#/bin/bash

yum update -y 
cp create100_Big_Files.sh ~/
chmod +x ~/create100_Big_Files.sh

wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo -O /etc/yum.repos.d/EGI-trust.repo
yum install ca-policy-egi-core -y

rpm -Uhv http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-sl92-9.2-8.noarch.rpm
wget http://www.dcache.org/downloads/1.9/repo/2.6/dcache-2.6.21-1.noarch.rpm -O ~/dcache-2.6.21-1.noarch.rpm 

yum install postgresql92-server.x86_64 -y
yum install java-1.7.0-openjdk.x86_64 -y
yum install nfs-utils -y

cp postgres.sh ~/configurepgsql.sh

echo "RPCBIND_ARGS=\"-i\"" > /etc/sysconfig/rpcbind

service rpcbind restart

echo "alias nfs-layouttype4-1 nfs_layout_nfsv41_files" > /etc/modprobe.d/dist-nfsv41.conf

modprobe nfs_layout_nfsv41_files

mv /etc/grid-security/hostkey.pem{,-pk8}
openssl rsa -in /etc/grid-security/hostkey.pem-pk8 -out /etc/grid-security/hostkey.pem


iptables -F
cp /etc/idmapd.conf /etc/idmapd.conf.bak
sed -ie 's/#Domain = local.domain.edu/Domain = desy2014-domain/' /etc/idmapd.conf
/etc/init.d/rpcidmapd restart
