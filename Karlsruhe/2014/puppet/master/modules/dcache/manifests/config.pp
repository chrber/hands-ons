class dcache::config(){

	notify{"Hello dCache users: now we configure all necessary services to run a dCache instance":}

        $grid_security_dir = "/etc/grid-security"

	file { $grid_security_dir:
		ensure => "directory",
		owner  => "root",
		group  => "root",
		mode   => "644";
		"$grid_security_dir/hostcert.pem":
		ensure => "present",
                owner  => "dcache",
		group  => "dcache",
		mode   => "u=rw,go=r";
		"$grid_security_dir/hostkey.pem":
		ensure => "present",
                owner  => "dcache",
		group  => "dcache",
		mode   => "u=rw,go=";
	}

	file { "/home/dcache/configurepgsql.sh": 
        ensure   => "present",
        owner    => "root",
        group    => "root",
        mode     => "u=rwx,go=rwx",
        source => "puppet:///modules/psql/configurepgsql.sh";
	}

}
