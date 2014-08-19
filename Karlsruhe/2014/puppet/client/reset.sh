#!/bin/bash

# author luca.mazzaferro@rzg.mpg.de

# This script reset the client system
# but doesn't delete the puppet package


LOCALUSR="dcache"
PUPPETCONF=/etc/puppet/puppet.conf 
# Remove the keys


if [ -f /home/$LOCALUSR/.ssh/id_rsa ]; then

    rm -f /home/$LOCALUSR/.ssh/id_rsa
    rm -f /home/$LOCALUSR/.ssh/id_rsa.pub
    echo "[INFO] key removed"
else
    echo "[WARNING] Keys not present"

fi	

if [ -f $PUPPETCONF ]; then

   sed  -i '/environment/d' $PUPPETCONF 
   sed  -i '/server/d' $PUPPETCONF
   echo "$PUPPETCONF cleaned"

else 
   echo "[WARNING] $PUPPETCONF not present"
fi

