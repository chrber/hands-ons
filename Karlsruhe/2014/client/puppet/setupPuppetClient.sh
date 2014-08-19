#!/bin/bash

# author luca.mazzaferro@rzg.mpg.de

# Script to install and configure the puppet client
# run it without options.

PUPPETCONF=/etc/puppet/puppet.conf
PUPPETMASTER="gks-121.scc.kit.edu"

#Install puppet repo

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# install puppet client

yum install -y puppet

# configure client for master connection.
if [ -e $PUPPETCONF ] 
  then
    echo "server = $PUPPETMASTER" >> $PUPPETCONF
  else 
    echo "[ERROR] PUPPETCONF variable missing"
    exit 1 
fi
