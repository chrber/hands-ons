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
        select * from pins where ipnfsid; in dcache database

* Add the new pool to the dCache

* rh restore the files to the newly added pool
