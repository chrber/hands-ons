#!/bin/sh

yum update -y

useradd dcacheuser

if [ ! -d /home/dcacheuser/.globus ]; 
then 
    mkdir /home/dcacheuser/.globus; 
else 
    echo "/home/dcacheuser/.globus already exists"; 
fi

mv /etc/grid-security/hostcert.pem /home/dcacheuser/usercert.pem
mv /etc/grid-security/hostkey.pem /home/dcacheuser/userkey.pem

wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo -O /etc/yum.repos.d/EGI-trust.repo
yum install ca-policy-egi-core -y

cp /etc/idmapd.conf /etc/idmapd.conf.bak
sed -ie 's/#Domain = local.domain.edu/Domain = taipei-domain/' /etc/idmapd.conf
/etc/init.d/rpcidmapd restart
