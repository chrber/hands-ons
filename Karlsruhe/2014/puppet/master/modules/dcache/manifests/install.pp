class dcache::install(){

	notify{"Hello dCache users: now we check installed packages":}

	Package { ensure => "installed" }
	$enhancers = [ "nfs-utils", "rpcbind" ]
	package { $enhancers: }

	notify{"Installing java-1.7.0-openjdk":}
	package{"java-1.7.0-openjdk":
		provider => "yum",
		ensure   => "installed",
	}

	notify{"Installing postgresql92":}
	package{"pgdg-redhat92-9.2-7.noarch.rpm":
		provider => "rpm",
		ensure   => "installed",
		source => 'http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-sl92-9.2-7.noarch.rpm',
	}
	
        $install = "dcache-2.10.0-1.noarch.rpm"

	notify{"Installing dcache  $install":}
	package{$install:
		provider => "rpm",
		ensure   => "installed",
		source   => "http://www.dcache.org/downloads/1.9/repo/2.10/dcache-2.10.0-1.noarch.rpm",
	}

	exec { "check_install":
		command => "yum list installed java-1.7.0-openjdk nfs-utils rpcbind > /tmp/check_install.out ; rpm -qa | grep -i dcache >> /tmp/check_install.out; rpm -qa | grep -i postgresql >> /tmp/check_install.out",
		path    => [ "/usr/local/bin/", "/bin/", "/usr/bin/" ],  
	}

}

