# Setup Replication

---

* Create Domain and replica cell

	    [replicaDomain]
	    [replicaDomain/replica]
		replica.poolgroup = ResilientPools
		replica.enable.same-host-replica=true
		replica.limits.replicas.min=2
		replica.limits.replicas.max=3

* Enable replication

        dcache.enable.replica = true

* Put pools into the replica pool group

* Just recently there was a command added to refetch the resilient pools when adding new pools to the PoolGroup: update poolgroup
