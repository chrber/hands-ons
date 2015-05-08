Admin Interface Scripting
============

* Scripting the admin interface using bash

        [root@vm-dcache-001 adminIfScripting]# cat admin_interface.sh
	    #!/bin/bash
            adminPort=22224

	    CMD="ssh -o StrictHostKeyChecking=no -l admin -p $adminPort localhost"
	    TMP=/tmp/$$_${RAND}.cmd

	    admin_interface() {
	       for i in "$@"
	       do
	         echo "$i" >> ${TMP}
	       done
	       echo ".."     >> ${TMP}
	       echo "logoff" >> ${TMP}
	       ${CMD} < $TMP 2>/dev/null | tr -d '\r'
	       rm -f ${TMP}
	    }

        Source the script
        . ./admin_interface.sh

        Get PnfsIDs of all files on a pool and then find the paths in the dCache namespace:

        [root@vm-dcache-001 adminIfScripting]# pnfsids=$(admin_interface "set timeout 500" "\s pool_write rep ls" | tr -d "\r" | egrep "^[0-9A-F]+{32}" | awk '{print $1}')

        [root@vm-dcache-001 adminIfScripting]# for pnfsid in ${pnfsids}; do path=$(admin_interface "\sn pathfinder $pnfsid" |  tr -d "\r" | egrep "^/"); echo $pnfsid $path; done
