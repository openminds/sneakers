default[:apache][:listen_ports] = [80]
default[:apache][:timeout] = 300
default[:apache][:keepalive] = "On"
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 15
default[:apache][:apache_run_user] = "www-data"
default[:apache][:apache_run_group] = "www-data"

default[:apache][:prefork][:startservers] = 4
default[:apache][:prefork][:minspareservers] = 2
default[:apache][:prefork][:maxspareservers] = 32
default[:apache][:prefork][:serverlimit] = 400
default[:apache][:prefork][:maxclients] = 400
default[:apache][:prefork][:maxrequestsperchild] = 10000

default[:apache][:worker][:startservers] = 4
default[:apache][:worker][:maxclients] = 1024
default[:apache][:worker][:minsparethreads] = 64
default[:apache][:worker][:maxsparethreads] = 192
default[:apache][:worker][:threadsperchild] = 64
default[:apache][:worker][:maxrequestsperchild] = 0

default[:apache][:fcgid][:IdleTimeout] = 120
default[:apache][:fcgid][:IdleScanInterval] = 30
default[:apache][:fcgid][:ErrorScanInterval] = 5
default[:apache][:fcgid][:ProcessLifeTime] = 84000
default[:apache][:fcgid][:MaxProcessCount] = 1000
default[:apache][:fcgid][:DefaultMaxClassProcessCount] = 5
default[:apache][:fcgid][:IPCConnectTimeout] = 60
default[:apache][:fcgid][:IPCCommTimeout] = 120
default[:apache][:fcgid][:FcgidMaxRequestsPerProcess] = 5000
default[:apache][:fcgid][:MaxRequestLen] = 134217728

default[:apache][:security][:servertokens] = "Prod"
default[:apache][:security][:serversignature] = "On"
default[:apache][:security][:traceenable] = "Off"

default[:apache][:modules_enabled] = ["actions","alias","auth_basic","authn_file","authz_default","authz_groupfile","authz_host","authz_user","autoindex","cgid","deflate","dir","env","expires","fastcgi","headers","mime","negotiation","rewrite","rpaf","setenvif","status","suexec","setenvif"]
