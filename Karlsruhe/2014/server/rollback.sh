#!/bin/bash
if [ -f ~/create100_Big_Files.sh ]; 
then
    rm ~/create100_Big_Files.sh
fi

POSTGRES_SERVER_COMMAND=/etc/init.d/postgresql-9.2
POSTGRES_DIRECTORY=/var/lib/pgsql/9.2
POSTGRES_CONFIG_SCRIPT=~/configurepgsql.sh
POSTGRES_PACKAGE=postgresql92-server
DCACHE_PACKAGE=dcache-2.10.0-1.noarch
DCACHE_RPM=~/$DCACHE_PACKAGE.rpm


$POSTGRES_SERVER_COMMAND status |grep running
rtn=$?
if [ $rtn -ne 0 ]; then
echo "Postgres Server not running"
else
echo "Postgres server running"
$POSTGRES_SERVER_COMMAND stop
echo "Deleting directory content: $POSTGRES_DIRECTORY"
rm -rf $POSTGRES_DIRECTORY/*
fi

rm $POSTGRES_CONFIG_SCRIPT
rm $DCACHE_RPM
chown root:root /etc/grid-security/host*

yum remove $DCACHE_PACKAGE $POSTGRES_PACKAGE

rm -rf /pools
rm -rf /data
