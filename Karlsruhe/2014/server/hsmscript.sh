#!/bin/sh
#
#set -x
#
logFile=/var/log/dcache/hsm.log
#
################################################################
#
#  Some helper functions
#
##.........................................
#
# print usage
#
usage() {
   echo "Usage : put|get <pnfsId> <filePath> [-si=<storageInfo>] [-key[=value] ...]" 1>&2
}
##.........................................
#
#
printout() {
#---------
   echo "$pnfsid : $1" >>${logFile}
   return 0
}
##.........................................
#
#  print error into log file and to stdout.
#
printerror() {
#---------

   if [ -z "$pnfsid" ] ; then
#      pp="000000000000000000000000000000000000"
      pp="------------------------------------"
   else
      pp=$pnfsid
   fi

   echo "$pp : (E) : $*" >>${logFile}
   echo "$pp : $*" 1>&2

}
##.........................................
#
#  find a key in the storage info
#
findKeyInStorageInfo() {
#-------------------

   result=`echo $si  | awk  -v hallo=$1 -F\; '{ for(i=1;i<=NF;i++){ split($i,a,"=") ; if( a[1] == hallo )print a[2]} }'| sed 's/>//'|sed 's/<//'`
   if [ -z "$result" ] ; then return 1 ; fi
   echo $result
   exit 0

}
##.........................................
#
#  find a key in the storage info
#
printStorageInfo() {
#-------------------
   printout "storageinfo.StoreName : $storeName"
   printout "storageinfo.store : $store"
   printout "storageinfo.group : $group"
   printout "storageinfo.hsm   : $hsmName"
   printout "storageinfo.accessLatency   : $accessLatency"
   printout "storageinfo.retentionPolicy : $retentionPolicy"
   return 0
}
##.........................................
#
#  assign storage info the keywords
#
assignStorageInfo() {
#-------------------

    store=`findKeyInStorageInfo "store"`
    group=`findKeyInStorageInfo "group"`
    storeName=`findKeyInStorageInfo "StoreName"`
    hsmName=`findKeyInStorageInfo "hsm"`
    accessLatency=`findKeyInStorageInfo "accessLatency"`
    retentionPolicy=`findKeyInStorageInfo "retentionPolicy"`
    return 0
}
##.........................................
#
# split the arguments into the options -<key>=<value> and the
# positional arguments.
#
splitArguments() {
#----------------
#
  args=""
  while [ $# -gt 0 ] ; do
    if expr "$1" : "-.*" >/dev/null ; then
       a=`expr "$1" : "-\(.*\)" 2>/dev/null`
       key=`echo "$a" | awk -F= '{print $1}' 2>/dev/null`
         value=`echo "$a" | awk -F= '{for(i=2;i<NF;i++)x=x $i "=" ; x=x $NF ; print x }' 2>/dev/null`
       if [ -z "$value" ] ; then a="${key}=" ; fi
       eval "${key}=\"${value}\""
       a="export ${key}"
       eval "$a"
    else
       args="${args} $1"
    fi
    shift 1
  done
  if [ ! -z "$args" ] ; then
     set `echo "$args" | awk '{ for(i=1;i<=NF;i++)print $i }'`
  fi
  return 0
}
#
#
##.........................................
#
splitUri() {
#----------------
#
  uri_hsmName=`expr "$1" : "\(.*\)\:.*"`
  uri_hsmInstance=`expr "$1" : ".*\:\/\/\(.*\)\/.*"`
  uri_store=`expr "$1" : ".*\/\?store=\(.*\)&group.*"`
  uri_group=`expr "$1" : ".*group=\(.*\)&bfid.*"`
  uri_bfid=`expr "$1" : ".*bfid=\(.*\)"`
#
  if [  \( -z "${uri_store}" \) -o \( -z "${uri_group}" \) -o \(  -z "${uri_bfid}" \) \
     -o \( -z "${uri_hsmName}" \) -o \( -z "${uri_hsmInstance}" \) ] ; then
     printerror "Illegal URI formal : $1"
     return 1
  fi
  return 0

}
#########################################################
#
echo "--------- $* `date`" >>${logFile}
#
#########################################################
#
createEnvironment() {

   if [ -z "${hsmBase}" ] ; then
      printerror "hsmBase not set, can't continue"
      return 1
   fi
   BASE=${hsmBase}/data
   if [ ! -d ${BASE} ] ; then
      printerror "${BASE} is not a directory or doesn't exist"
      return 1
   fi
}
##
#----------------------------------------------------------
doTheGetFile() {

   splitUri $1
   [ $? -ne 0 ] && return 1

   createEnvironment
   [ $? -ne 0 ] && return 1

   pnfsdir=${BASE}/$uri_hsmName/${uri_store}/${uri_group}
   pnfsfile=${pnfsdir}/$pnfsid

   cp $pnfsfile $filename 2>/dev/null
   if [ $? -ne 0 ] ; then
      printerror "Couldn't copy file $pnfsfile to $filename"
      return 1
   fi

   return 0
}
##
#----------------------------------------------------------
doTheStoreFile() {

   splitUri $1
   [ $? -ne 0 ] && return 1

   createEnvironment
   [ $? -ne 0 ] && return 1

   pnfsdir=${BASE}/$hsmName/${store}/${group}
   mkdir -p ${pnfsdir} 2>/dev/null
   if [ $? -ne 0 ] ; then
      printerror "Couldn't create $pnfsdir"
      return 1
   fi
   pnfsfile=${pnfsdir}/$pnfsid

   cp $filename $pnfsfile 2>/dev/null
   if [ $? -ne 0 ] ; then
      printerror "Couldn't copy file $filename to $pnfsfile"
      return 1
   fi

   return 0

}
##
#----------------------------------------------------------
doTheRemoveFile() {

   splitUri $1
   [ $? -ne 0 ] && return 1

   createEnvironment
   [ $? -ne 0 ] && return 1

   pnfsdir=${BASE}/$uri_hsmName/${uri_store}/${uri_group}
   pnfsfile=${pnfsdir}/$uri_bfid

   rm $pnfsfile 2>/dev/null
   if [ $? -ne 0 ] ; then
      printerror "Couldn't remove file $pnfsfile"
      return 1
   fi

   return 0
}
#########################################################
#
#  split arguments
#
  args=""
  while [ $# -gt 0 ] ; do
    if expr "$1" : "-.*" >/dev/null ; then
       a=`expr "$1" : "-\(.*\)" 2>/dev/null`
       key=`echo "$a" | awk -F= '{print $1}' 2>/dev/null`
         value=`echo "$a" | awk -F= '{for(i=2;i<NF;i++)x=x $i "=" ; x=x $NF ; print x }' 2>/dev/null`
       if [ -z "$value" ] ; then a="${key}=" ; fi
       eval "${key}=\"${value}\""
       a="export ${key}"
       eval "$a"
    else
       args="${args} $1"
    fi
    shift 1
  done
  if [ ! -z "$args" ] ; then
     set `echo "$args" | awk '{ for(i=1;i<=NF;i++)print $i }'`
  fi
#
#
if [ $# -lt 1 ] ; then
    printerror "Not enough arguments : ... put/get/remove ..."
    exit 1
fi
#
command=$1
pnfsid=$2
#
# !!!!!!  Hides a bug in the dCache HSM remove
#
if [ "$command" = "remove" ] ; then pnfsid="000000000000000000000000000000000000" ; fi
#
#
printout "Request for $command started `date`"
#
################################################################
#
if [ "$command" = "put" ] ; then
#
################################################################
#
  filename=$3
#
  if [ -z "$si" ] ; then
     printerror "StorageInfo (si) not found in put command"
     exit 5
  fi
#
  assignStorageInfo
#
  printStorageInfo
#
  if [ \( -z "${store}" \) -o \( -z "${group}" \) -o \( -z "${hsmName}" \) ] ; then
     printerror "Didn't get enough information to flush : hsmName = $hsmName store=$store group=$group pnfsid=$pnfsid "
     exit 3
  fi
#
  uri="$hsmName://$hsmName/?store=${store}&group=${group}&bfid=${pnfsid}"

  printout "Created identifier : $uri"

  doTheStoreFile $uri
  rc=$?
  if [ $rc -eq 0 ] ; then echo $uri ; fi

  printout "Request 'put' finished at `date` with return code $rc"
  exit $rc
#
#
################################################################
#
elif [ "$command" = "get"  ] ; then
#
################################################################
#
  filename=$3
  if [ -z "$uri" ] ; then
     printerror "Uri not found in arguments"
     exit 3
  fi
#
  printout "Got identifier : $uri"
#
  doTheGetFile $uri
  rc=$?
  printout "Request 'get' finished at `date` with return code $rc"
  exit $rc
#
################################################################
#
elif [ "$command" = "remove" ] ; then
#
################################################################
#
   if [ -z "$uri" ] ; then
      printerror "Illegal Argument error : URI not specified"
      exit 4
   fi
#
   printout "Remove uri = $uri"
   doTheRemoveFile $uri
   rc=$?
#
   printout "Request 'remove' finished at `date` with return code $rc"
   exit $rc
#
else
#
   printerror "Expected command : put/get/remove , found : $command"
   exit 1
#
fi
