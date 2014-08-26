class dcache{

	#include install
	#include config

        #class{'dcache::install':
	#}


        #class{'dcache::config':
	#    require=>Class['dcache::install']
        #}
}
