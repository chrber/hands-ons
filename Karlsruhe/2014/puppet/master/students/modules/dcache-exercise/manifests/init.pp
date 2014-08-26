class dcache-exercise{

        file { "/etc/dcache/dcache.conf":
        ensure   => "present",
        owner    => "root",
        group    => "root",
        mode     => "u=rw,go=r",
        source => "puppet:///modules/dcache-exercise/dcache.conf";
        }

        file { "/etc/dcache/layouts/ws_gridka_2014.conf":
        ensure   => "present",
        owner    => "root",
        group    => "root",
        mode     => "u=rw,go=r",
        source => "puppet:///modules/dcache-exercise/ws_gridka_2014.conf";
        }


}
