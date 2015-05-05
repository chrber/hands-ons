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

* Sharing a file with another user:

        nfs4_setfacl -a A::502:r ifcfg-eth0
