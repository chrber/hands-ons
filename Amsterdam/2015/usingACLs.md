Introduction to ACLs in dCache
=============

https://indico.desy.de/getFile.py/access?contribId=3&resId=0&materialId=slides&confId=7596

Using ACLs in dCache
=============

* Enable ACLs in layout file:

                 [dCacheDomain/pnfsmanager]
                 pnfsmanager.enable.acl = true

* Export file should contain:

        / localhost(rw,root_squash,acl)

* Mount nfs with vers=4.1 

* Client side altering ACLs:

        nfs4_setfacl -e <directory path | file>

* Admin interface altering ACLs:

        [vm-dcache-001] (PnfsManager@dCacheDomain) admin > getfacl <directory path | file>
        [vm-dcache-001] (PnfsManager@dCacheDomain) admin > setfacl <pnfsId|globalPath>  <subject>:<+|-><access_msk>[:<flags>] [ ... ] # set a new ACL

* Checking directory ACLs:

        [aclUserElon@vm-dcache-001 aclUserElon]$ pwd
	/mnt/acl/aclUserElon
	[aclUserElon@vm-dcache-001 aclUserElon]$ nfs4_getfacl .
	A::OWNER@:rwaDxtTcC
	A:g:GROUP@:rxtc
	A::EVERYONE@:rxtc 

* Sharing a file with another user (if directory permissions to execute, list is not set, this does not work):

        nfs4_setfacl -a A::502:r ifcfg-eth0

* Reducing rights on directory to see effect:
       
 	aclUserElon@vm-dcache-001 aclUserElon]$ nfs4_setfacl -e <directory name> 
	\#\# Editing NFSv4 ACL for directory: /mnt/acl/aclUserElon
	A::OWNER@:rwaDxtTcC
	A:g:GROUP@:rtc
	A::EVERYONE@:rtc

* Try reading a file, this should not work in the directory we just restricted execution (this is the same as list for directories) 

* Create a directory and make it accessible for another user, allow creation of files and inheritance of rights on files and directories

        nfs4_setfacl -e /mnt/acl/aclUserElon/forTim/  
        A:fd:502:rwaDxtTcC


