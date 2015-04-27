Migrate from one tape system to another
=====================

Preparation:

 * Each file in a pool has one of the 4 primary states: “cached” (<C---), “precious” (<-P--), “from client” (<--C-), and “from store” (<---S).

Procedure:

 * Remove old hsm instance entry from pools that are connected to the old tape system
 
        [vm-dcache-001] (pool_write@writePoolDomain) admin > hsm remove osm
        [vm-dcache-001] (pool_write@writePoolDomain) admin > hsm create osm osmNew -command=/usr/share/dcache/lib/hsmcp.rb -hsmBase=/hsmTape_new/data -hsmInstance=osmNew

* Configure one read pool and one write pool

        [root@vm-dcache-001 ~]# dcache pool create --size=419430400  --meta=db --lfs=precious /var/pools/tapeMigrationWritePool tapeMigrationWritePool tapeMigrationPoolDomain
        [root@vm-dcache-001 ~]# dcache pool create --size=419430400  --meta=db --lfs=precious /var/pools/tapeMigrationReadPool tapeMigrationReadPool tapeMigrationPoolDomain

* Create read only link and write only links, connect them to the pools

        psu create link tape-write-link tape-store world-net any-protocol
        psu set link tape-write-link -readpref=0 -writepref=10 -cachepref=0 -p2ppref=0
        psu create link tape-read-link tape-store world-net any-protocol
        psu set link tape-read-link -readpref=10 -writepref=0 -cachepref=10 -p2ppref=0
        psu add link tape-write-link tapeMigrationWritePool
        psu add link tape-read-link tapeMigrationReadPool

* Create hsm entries on the pools, the old instance connected to the read pool and the new instance connected to the write pool

        [vm-dcache-001] (tapeMigrationReadPool@tapeMigrationPoolDomain) admin > hsm create osm osm -hsmInstance=osm -command=/usr/share/dcache/lib/hsmcp.rb -hsmBase=/hsmTape/data
        [vm-dcache-001] (tapeMigrationWritePool@tapeMigrationPoolDomain) admin > hsm create osm osmNew -hsmInstance=osmNew -hsmBase=/hsmTape_new/data -command=/usr/share/dcache/lib/hsmcp.rb -c:gets=1 -c:puts=1 -c:removes=1

* Check of there are files on the tapeMigrationReadPool

        [vm-dcache-001] (tapeMigrationReadPool@tapeMigrationPoolDomain) admin > rep ls

* Get a list of files per tape from the tape administration

* Add the command to the pnfsID list:

        [root@vm-dcache-001 ~]# vi pnfsIdList, :%s/^/\\s tapeMigrationReadPool rh restore /g 

* Send the commands to the dCache admin insterface:

        [root@vm-dcache-001 ~]# ssh -l admin -p 22224 localhost < allPnfsIDs_oldHSM_rhRestore
 
* Migration move the files from the read pool to the write pool

        [vm-dcache-001] (tapeMigrationReadPool@tapeMigrationPoolDomain) admin > migration move -concurrency=8 -smode=delete -tmode=precious -target=pool tapeMigrationWritePool

* Flush files from write pool to the new tape system (flush pnfsid)

        [root@vm-dcache-001 ~]# ssh -l admin -p 22224 localhost < allPnfsIDs_oldHSM_flush

* Check if all files have an entry on the new tape system and in the t_locationinfo table
   * Create tmp table in database with all pnfsIDs

        chimera=# create TEMP table tmp_ids (id character varying(36));
        chimera=# copy tmp_ids from '/tmp/allPnfsIDs_oldHSM';

   * Check against t_locationinfo table

        chimera=# select ipnfsid,ilocation from t_locationinfo where ipnfsid in (Select id from tmp_ids) AND ilocation like 'hsm://osm/%';

   * Check number of entries above against the row count in the CSV file

        wc -l /tmp/allPnfsIDs_oldHSM

* Delete entries from t_locationinfo, with the old tape (allthough this step can be ommitted as it does not hurt)

    chimera=# delete from t_locationinfo where ipnfsid in (Select id from tmp_ids) AND ilocation like 'hsm://osm/%'; 
