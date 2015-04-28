# Debug FTS transfer

---

Have srm.persistence.enable.history=true --> allows you better debugging

Example: Billing logs: this shows is the pnfsID and the TURL

    02.20 18:40:42 [pool:dcache-atlas72-03@dcache-atlas72-03Domain:remove] [00003EBBDE28AA514ABB890769FD718A4D27,6398872127] [Unknown] atlas:atlasproddisk@osm {0:""}
    02.20 18:40:44 [pool:dcache-atlas72-03:transfer] [00003EBBDE28AA514ABB890769FD718A4D27,6398872127] [/upload/b4285977-33c8-4904-a7fc-c4104dd4bac6/AOD.01534542._000072.pool.root.1] atlas:atlasproddisk@osm 6398872127 6171563 true {GFtp-2.0 145.100.32.111 60089} [door:GFTP-dcache-door-atlas14-499890@gridftp-dcache-door-atlas14Domain:1424447822672-1424447823185] {10001:"No such file or directory: 00003EBBDE28AA514ABB890769FD718A4D27"}

Get the SRM transfer ID from the database: —> the unique part of the TURL is needed for the query

    dcache=# select * from putfilerequests where turl ilike ‘%b4285977-33c8-4904-a7fc-c4104dd4bac6%';
    id      | nextjobid | creationtime  | lifetime | state |                               errormessage                                | schedulerid | schedulertimestamp | numofretr | maxnumofretr | laststatetransitiontime |  requestid  | credentialid | status
code |                                                                        surl                                                                         |                                                          turl
                |                                    fileid                                     | parentfileid | spacereservationid |    size    | retentionpolicy | accesslatency
-------------+-----------+---------------+----------+-------+---------------------------------------------------------------------------+-------------+--------------------+-----------+--------------+-------------------------+-------------+--------------+-------
-----+-----------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------
----------------+-------------------------------------------------------------------------------+--------------+--------------------+------------+-----------------+---------------
 -1193254804 |           | 1424447822548 |  3600000 |    11 |  at Fri Feb 20 17:57:12 CET 2015 state Failed : Request lifetime expired. |             |      1424430720535 |         0 |           10 |           1424451432775 | -1193254805 |  -2034723623 |
     | srm://dcache-se-atlas.desy.de:8443/srm/managerv2?SFN=/pnfs/desy.de/atlas/dq2/atlasproddisk/rucio/data12_8TeV/78/9b/AOD.01534542._000072.pool.root.1 | gsiftp://dcache-door-atlas14.desy.de:2811//upload/b4285977-33c8-4904-a7fc-c4104dd4bac6/AOD.01534542._000
072.pool.root.1 | /upload/b4285977-33c8-4904-a7fc-c4104dd4bac6/AOD.01534542._000072.pool.root.1 |              | 310019             | 6398872127 |                 |
(1 row)

Use SRM transfer id in the admin interface

    [dcache-core-atlas03.desy.de] (SRM-dcache-se-atlas03) admin > ls -l "-1193254804"
                Put file id:-1193254804 state:Failed
                   SURL: srm://dcache-se-atlas.desy.de:8443/srm/managerv2?SFN=/pnfs/desy.de/atlas/dq2/atlasproddisk/rucio/data12_8TeV/78/9b/AOD.01534542._000072.pool.root.1
                   TURL: gsiftp://dcache-door-atlas14.desy.de:2811//upload/b4285977-33c8-4904-a7fc-c4104dd4bac6/AOD.01534542._000072.pool.root.1
                   Size: 6398872127
                   Access latency: null
                   Retention policy: null
                   Space reservation: 310019
                   History:
                      2015-02-20 16:57:02.548 Pending: Request created (0 ms)
                      2015-02-20 16:57:02.548 TQueued: Request enqueued. (1 ms)
                      2015-02-20 16:57:02.549 PriorityTQueued: Waiting for thread. (0 ms)
                      2015-02-20 16:57:02.549 Running: Processing request (0 ms)
                      2015-02-20 16:57:02.549 Running: run method is executed (0 ms)
                      2015-02-20 16:57:02.549 AsyncWait: Doing name space lookup. (35 ms)
                      2015-02-20 16:57:02.584 PriorityTQueued: Waiting for thread. (0 ms)
                      2015-02-20 16:57:02.584 Running: Processing request (0 ms)
                      2015-02-20 16:57:02.584 Running: run method is executed (0 ms)
                      2015-02-20 16:57:02.584 RQueued: Putting on a "Ready" Queue. (0 ms)
                      2015-02-20 16:57:02.584 Ready: Execution succeeded. (60 min)
                      2015-02-20 17:57:12.775 Failed: Request lifetime expired.

