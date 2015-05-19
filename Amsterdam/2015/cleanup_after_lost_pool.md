Clean up after lost pool
===============

This assumes that you have a hsm to recover files from tape. If this is not the case you will have replication in place and the files will be on some other pool or they are simply lost.


* You could either just wait for the files to be restored from tape after you deleted the files form the location info table for the pools.

* Get a list of the files that were on the pool

        chimera=# \o allFilesOnR1
        chimera=# select ipnfsid from t_locationinfo where ilocation='pool-name' and itype=1;

* First, delete entries from t_locationinfo:

        delete from t_locationinfo where ilocation='pool-name' and itype=1;

	1 == pool
	0 == tape

* What to do with pinned files?

        create TEMP table tmp_ids(id character varying(50));
        COPY tmp_ids FROM '/tmp/allFilesOnR1'; (you have to alter the file, delete the header, to just have pnfsids)
        select * from pins where ipnfsid; in dcache database and delete these pins

* Add the new pool to the dCache

* rh restore the files to the newly added pool or let them restore as they are read again.

Another case (more complicated) is when we have a non-resilient disk only pool, but we might still have cached copies around, which we could restore.

 * Check which files were on lost pool (list of pnfsIDs)
 * Check which of the lost files might be on tape --> t_locationinfo itype=0 (subtract these from the above pnfsIDs)
 * Which might be cached on some other pool (hot spot reps) and are cached or as primary copy on some other pool(if primary, subtract them from the list, if cached put them precious there or migration move them to a pool that is save and put them precious there. After that remove them from the list)
 * Remove the resulting list from the t_locationinfo with the ilocation of the lost pool_name
 * Also clean up t_locationinfo_trash
 * The resulting list is the list of lost files. (Ask chimera for the paths and appologise to your users that you lost the files, send them the list and let them delete them from the namespace, catalog)

