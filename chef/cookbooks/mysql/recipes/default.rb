service "mysql"
node.set['mysql']['mysql_root_pass'] = "vagrant"

apt_repository "mariadb" do
  uri "http://mirror2.hs-esslingen.de/mariadb/repo/5.5/debian"
  distribution "squeeze"
  components ["main"]
  key "1BB943DB"
  keyserver "keyserver.ubuntu.com"
  action :add
end

directory "/var/cache/local/preseeding" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

execute "preseed mysql-server" do
  command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
  action :nothing
end

template "/var/cache/local/preseeding/mysql-server.seed" do
  source "5.5mariadb.seed.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, resources(:execute => "preseed mysql-server"), :immediately
end

package "mariadb-server-5.5"

include_recipe "mysql::configuration"
include_recipe "mysql::tuning"
