# Pool Decommissioning

---

* Set the pool read-only

        [vm-dcache-001] (chrisPool@dCacheDomain) admin > pool disable -rdonly 

* Move data off the pool (migration move -target=pool | pgroup | link)

        [vm-dcache-001] (chrisPool@dCacheDomain) admin > migration move -target=pool pool_r3

        or

        [vm-dcache-001] (chrisPool@resilientChrisPoolsDomain) admin > migration move -target=pgroup ResilientPools

* Make sure no file is left on the pool

        [vm-dcache-001] (chrisPool@dCacheDomain) admin > rep ls

* Stop the pool

        [root@vm-dcache-001 resilient]# dcache stop resilientChrisPoolsDomain

* Remove pool/domain from layoutfile

* Remove pool from PoolGroup

        [vm-dcache-001] (PoolManager@dCacheDomain) admin > psu removefrom pgroup ResilientPools chrisPool

* Remove pool from PoolManager

        [vm-dcache-001] (PoolManager@dCacheDomain) admin > psu remove pool chrisPool

* Remove directory structure from actual backend storage
