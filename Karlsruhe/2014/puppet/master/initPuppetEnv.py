#!/bin/python

#
# This program creates the puppet directory enviroment 
# for a new user and deployes also the enviroment.conf file
# and the init.sh for the gitolite sinchronization.
#
# Synopsis:
#
# python initPuppetEnv.py username
# 

import sys
import os

#Config variables
puppet_uid = 52 
puppet_gid = 52

# Create the environment directory.
# By default it will be created into /etc/puppet/environments
def create_dir(name,path = "/etc/puppet/environments"):

    directory = path + "/" + name
    if not os.path.exists(directory):
        os.makedirs(directory)
	os.chown(directory,puppet_uid,puppet_gid)
	print("Directory %s created" % directory)
    else:
	print("Directory %s already created" % directory)
   
    return directory 

# Create and write the environment.conf file
def create_envconf(path,name="environment.conf"):   
 
    filename = path + '/' + name 

    print filename

    file = open(filename, 'w') 
    file.write('config_version = init.sh')
    file.close()

    os.chown(filename, puppet_uid,puppet_gid)
    os.chmod(filename, 0664)
    
    print("%s created" % filename)

# Create and write the init.sh script for 
# puppet-gitolite sinchronization
def create_init(path,username,name="init.sh"):

    filename     = path + '/' + name
    gitdirectory = 'environments/' + username 

    print filename

    file = open(filename, 'w')
    file.write(
"""#!/bin/bash
# This script is called by puppet 
# before to apply the changes on the nodes 
# and it runs on the master.
# It synchrinizes the code with gitolite

echo "apply the last config" >&2
DIRECTORY=%s
GITDIRECTORY=%s

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
""" % (path,gitdirectory) )
    file.close()

    os.chown(filename, puppet_uid,puppet_gid)
    os.chmod(filename, 0774)

    print("%s created" % filename)

# Execute the code
def start():

    arg_list = sys.argv
    print arg_list

    if len(arg_list) < 2:

        print "provide the name of the user \n python initPuppetEnv.py usernames"
	raise SystemExit

    name = arg_list[1]

    if name: 
	
	directory = create_dir(name)
	create_envconf(directory)
	create_init(directory,name)

    print "Initialization completed."

start()
