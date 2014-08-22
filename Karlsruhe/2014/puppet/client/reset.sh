#!/bin/bash

# author luca.mazzaferro@rzg.mpg.de

# This script reset the client system
# but doesn't delete the puppet package


LOCALUSR="dcache"
PUPPETCONF=/etc/puppet/puppet.conf 
PUPPETDIR=/etc/puppet
PUPPETWORK=/var/lib/puppet
PUPPETCERT=/var/lib/puppet/ssl
# Remove the keys


while test $# -gt 0; do
  opt="$1";
  shift;
  case "$opt" in
    -h)
	echo "[INFO] This package reset the client machine"
	echo "[INFO] --remove_keys privkeypath removes only the ssh keys of the user"
        echo "[INFO] --remove_puppet removes puppet package and configurations"
	echo "[INFO] --reset_cert removes the puppet ssl certificates"
	echo "[INFO] $0 [--remove_keys privkeypath] [--remove_puppet] [--reset_cert]"
	exit 0
	;;
    --remove_keys)
	KEYS=true
	USERKEYPATH=$1
	;;	
    --remove_puppet)
	PUPREM=true
        ;;
    --reset_cert)
        RESCERT=true
        ;;
  esac
done

# Remove the user keys used for gitolite
if [ $KEYS ]; then

    if [ -f $USERKEYPATH ]; then

        rm -f $USERKEYPATH
        rm -f $USERKEYPATH.pub
        retcode=$?
	if [ $retcode -eq 0 ]; then
            echo "[INFO] $USERKEYPATH and $USERKEYPATH.pub removed"
	else
            echo "[ERROR] $USERKEYPATH and $USERKEYPATH.pub not removed"
            exit $retcode
        fi
    else
        echo "[WARNING] Keys not present"
    fi

else

    echo "[INFO] keys not removed"

fi	


# Remove puppet ssl certificate and key
if [ $RESCERT ] && [ ! $PUPREM ] ; then

    if [ -d $PUPPETCERT ]; then
	rm -fr $PUPPETCERT
	retcode=$?
        if [ $retcode -eq 0 ]; then
            echo "[INFO] $PUPPETCERT removed"
        else
            echo "[ERROR] $PUPPETCERT not removed"
            exit $retcode
        fi

    else
        echo "[WARNING] $PUPPETCERT not present"
    fi


else
    echo "[INFO] ssl certificate not removed"
fi

# Remove the entire puppet package
if [ $PUPREM ]; then
    
    #sed  -i '/environment/d' $PUPPETCONF 
    #sed  -i '/server/d' $PUPPETCONF


    rpm -e --nodeps puppet
    retcode=$?
    if [ $retcode -eq 0 ]; then
        echo "[INFO] puppet package removed"
    else 
        echo "[ERROR] puppet package not removed"
        exit $retcode
    fi
	 
    if [ -d $PUPPETDIR ]; then
    
        rm -fr $PUPPETDIR
	retcode=$?
        if [ $retcode -eq 0 ]; then
            echo "[INFO] $PUPPETDIR removed"
	else 
	    echo "[ERROR] $PUPPETDIR not removed"
	    exit $retcode
	fi

    else 
        echo "[WARNING] $PUPPETDIR not present"
    fi

    if [ -d $PUPPETWORK ]; then
    
        rm -fr $PUPPETWORK
        if [ $retcode -eq 0 ]; then
            echo "[INFO] $PUPPETWORK removed"
	else 
	    echo "[ERROR] $PUPPETWORK not removed"
	    exit $retcode
	fi
    
    else 
        echo "[WARNING] $PUPPETCONF not present"
    fi

else 
    echo "[INFO] puppet package not removed "
fi

