#!/bin/bash
# This script is called by puppet 
# before to apply the changes on the nodes 
# and it runs on the master.
# It synchrinizes the code with gitolite
#
# author luca.mazzaferro@rzg.mpg.de
#
echo "apply the last config" >&2
DIRECTORY=/etc/puppet/environments/gks124
GITDIRECTORY=environments/gks124

if [ -d $DIRECTORY/modules ]; then  
    cd $DIRECTORY/modules
    git pull origin 1>&2
else 
    cd $DIRECTORY
    git clone gitolite@gks-121.scc.kit.edu:$GITDIRECTORY/modules 1>&2
fi

if [ -d $DIRECTORY/manifests ]; then
    cd $DIRECTORY/manifests
    git pull origin 1>&2
else
    cd $DIRECTORY 1>&2
    git clone gitolite@gks-121.scc.kit.edu:$GITDIRECTORY/manifests 1>&2 
fi

exit 0

