#!/bin/sh
cp /etc/idmapd.conf /etc/idmapd.conf.bak
sed -ie 's/#Domain = local.domain.edu/Domain = taipei-domain/' /etc/idmapd.conf
/etc/init.d/rpcidmapd restart
