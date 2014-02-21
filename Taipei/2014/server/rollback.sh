#!/bin/bash
POSTGRES_SERVER_COMMAND=/etc/init.d/postgresql-9.2
POSTGRES_DIRECTORY=/var/lib/pgsql/9.2
POSTGRES_CONFIG_SCRIPT=~/configurepgsql.sh
DCACHE_RPM=~/dcache-2.6.21-1.noarch.rpm

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

