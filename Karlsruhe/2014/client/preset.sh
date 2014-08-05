#!/bin/sh

yum update -y

useradd dcacheuser

if [ ! -d /home/dcacheuser/.globus ]; 
then 
    mkdir /home/dcacheuser/.globus; 
else 
    echo "/home/dcacheuser/.globus already exists"; 
fi

cp /etc/grid-security/hostcert.pem /home/dcacheuser/.globus/usercert.pem
cp /etc/grid-security/hostkey.pem /home/dcacheuser/.globus/userkey.pem

chown dcacheuser:dcacheuser -R /home/dcacheuser/.globus


wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo -O /etc/yum.repos.d/EGI-trust.repo
yum install ca-policy-egi-core -y

cp /etc/idmapd.conf /etc/idmapd.conf.bak
sed -ie 's/#Domain = local.domain.edu/Domain = taipei-domain/' /etc/idmapd.conf
/etc/init.d/rpcidmapd restart

rpm -ivh ca_dCacheORG-2.1-1.noarch.rpm
