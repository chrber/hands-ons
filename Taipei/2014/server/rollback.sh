#!/bin/bash
POSTGRES_SERVER_COMMAND=/etc/init.d/postgresql-9.2
POSTGRES_DIRECTORY=/var/lib/pgsql/9.2

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


