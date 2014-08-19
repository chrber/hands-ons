#!/bin/bash

# Author: luca.mazzaferro@rzg.mpg.de

# Use this script to register a new machine to gitolite and puppet
# it will generate also a couple of keys 
# Because all the client machines will have the same user "dcache"
# and gitolite requires different ssh-key and users, when running this script
# you need to provide the gitolite username you want to use. The convention
# is to use the client machine short hostname without the "-", which is not recognized by puppet.
# e.g.
# source addNewUser.sh -u gsk124 -e 
#

USER=""
PUPPETCONF=/etc/puppet/puppet.conf

while test $# -gt 0; do
  opt="$1";
  shift;
  case "$opt" in
    -h)
	echo "[INFO] This package add the user to the puppet env and creates keys pairs to interact with gitolite"
	echo "[INFO] Insert the name of the students group as the short hostname without minus sign "
        echo "[INFO] and eventually if you want to setup puppet environment: -e option"
	echo "[INFO] $0 -u gskwhatever [-e]"
	exit 0
	;;
    -u)
	USER=$1
	;;	
    -e)
	if [ $USER ]; then
	  echo "    environment = $USER" >> $PUPPETCONF
	  echo "[INFO] New environment $USER define into $PUPPETCONF"
	fi
  esac
done


LOCALUSR="dcache"	
if [ $USER ]; then


  #useradd -m $USER
  if [ ! -f /home/$LOCALUSR/.ssh/id_rsa ]; then
      su $LOCALUSR -c "ssh-keygen -t rsa -f /home/$LOCALUSR/.ssh/id_rsa -N ''"
      chmod 400 /home/$LOCALUSR/.ssh/id_rsa
      echo "[INFO] User $LOCALUSR created and new passwordless keypair generated."
      echo "[INFO] Give the public key to the gitolite admin for user interaction"
  else
      echo "[WARNING] The ssh user keys already exists"
  fi


else   

  echo "[ERROR] No user defined, -h for help"
  exit 1
fi
