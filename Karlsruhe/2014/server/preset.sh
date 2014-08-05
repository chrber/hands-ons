#/bin/bash

#
#
# This file is expected to be executed from the this directory as user root
#
#

yum update -y 
cp create100_Big_Files.sh ~/
chmod +x ~/create100_Big_Files.sh

wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo -O /etc/yum.repos.d/EGI-trust.repo
yum install ca-policy-egi-core -y

rpm -Uhv http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-sl92-9.2-8.noarch.rpm
wget http://www.dcache.org/downloads/1.9/repo/2.10/dcache-2.10.0-1.noarch.rpm -O ~/dcache-2.10.0-1.noarch.rpm 

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

rpm -ivh ca_dCacheORG-2.1-1.noarch.rpm 
yum install epel-release.noarch
yum install fetch-crl.noarch
fetch-crl
