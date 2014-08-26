node "gks-<machine number>.scc.kit.edu" {
        
        class{'dcache::install':
            before=>Class['dcache::config']
        }
        class{'dcache::config':
            before=>Class['dcache-exercise']
        }
        class{'dcache-exercise':
        }


}
