Migrate from one tape system to another
=====================

Preparation:

 * Each file in a pool has one of the 4 primary states: “cached” (<C---), “precious” (<-P--), “from client” (<--C-), and “from store” (<---S).

Conditions which justify this procedure:

 * The new and old tape system are not compatible, otherwise direct copy between them is possible.
 * Tape systems are distributed, maybe even in different countries (like in the case of NDGF)
 * Direct scp does not work for any reason

Procedure:

 * Remove old hsm instance entry from pools that are connected to the old tape system
 
        [vm-dcache-001] (pool_write@writePoolDomain) admin > hsm remove osm
        [vm-dcache-001] (pool_write@writePoolDomain) admin > hsm create osm osmNew -command=/usr/share/dcache/lib/hsmcp.rb -hsmBase=/hsmTape_new/data -hsmInstance=osmNew

* Configure one read pool and one write pool (you should choose a pool size that allows you to transfer a certain amount of tapes per run, as you will do this is bunches of tapes, not all tapes at once)

        [root@vm-dcache-001 ~]# dcache pool create --size=419430400  --meta=db --lfs=precious /var/pools/tapeMigrationWritePool tapeMigrationWritePool tapeMigrationPoolDomain
        [root@vm-dcache-001 ~]# dcache pool create --size=419430400  --meta=db --lfs=precious /var/pools/tapeMigrationReadPool tapeMigrationReadPool tapeMigrationPoolDomain

* Create hsm entries on the pools, the old instance connected to the read pool and the new instance connected to the write pool

        [vm-dcache-001] (tapeMigrationReadPool@tapeMigrationPoolDomain) admin > hsm create osm osm -hsmInstance=osm -command=/usr/share/dcache/lib/hsmcp.rb -hsmBase=/hsmTape/data -c:gets=1 -c:puts=1 -c:removes=1
        [vm-dcache-001] (tapeMigrationWritePool@tapeMigrationPoolDomain) admin > hsm create osm osmNew -hsmInstance=osmNew -hsmBase=/hsmTape_new/data -command=/usr/share/dcache/lib/hsmcp.rb -c:gets=1 -c:puts=1 -c:removes=1

* Check if there are files on the tapeMigrationReadPool

        [vm-dcache-001] (tapeMigrationReadPool@tapeMigrationPoolDomain) admin > rep ls

* Get a list of files per tape from the tape administration
        * You would get it from the tape admin
        * We get it from our t_locationinfo as we basically have one tape, you will have many.

* Migration move the files from the read pool to the write pool

        [vm-dcache-001] (tapeMigrationReadPool@tapeMigrationPoolDomain) admin > migration move -permanent -concurrency=8 -smode=delete -tmode=precious -target=pool tapeMigrationWritePool

* Add the restore command to the pnfsID list:

        [root@vm-dcache-001 ~]# vi pnfsIdList, :%s/^/\\s tapeMigrationReadPool rh restore /g 

* Send the commands to the dCache admin insterface:

        [root@vm-dcache-001 ~]# ssh -l admin -p 22224 localhost < allPnfsIDs_oldHSM_rhRestore
 
* Flush files from write pool to the new tape system (flush pnfsid)

        [root@vm-dcache-001 ~]# ssh -l admin -p 22224 localhost < allPnfsIDs_oldHSM_flush

* Check if all files have an entry on the new tape system and in the t_locationinfo table
   * Create tmp table in database with all pnfsIDs

            chimera=# create TEMP table tmp_ids (id character varying(36));
            chimera=# copy tmp_ids from '/tmp/allPnfsIDs_oldHSM'; (this files can not be in /root, put it to where the postgres user can read it)

   * Check against t_locationinfo table

             chimera=# select ipnfsid,ilocation from t_locationinfo where ipnfsid in (Select id from tmp_ids) AND ilocation like 'hsm://osm/%';

   * Check number of entries above against the row count in the CSV file

            wc -l /tmp/allPnfsIDs_oldHSM

* Delete entries from t_locationinfo, with the old tape (allthough this step can be ommitted as it does not hurt)

            chimera=# delete from t_locationinfo where ipnfsid in (Select id from tmp_ids) AND ilocation like 'hsm://osm/%'; 
