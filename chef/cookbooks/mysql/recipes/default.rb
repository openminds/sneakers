node.set['mysql']['mysql_root_pass'] = 'vagrant'

execute 'preseed mysql-server' do
  command 'debconf-set-selections /var/cache/local/preseeding/mysql-server.seed'
  action :nothing
end

template '/var/cache/local/preseeding/mysql-server.seed' do
  source '5.5mariadb.seed.erb'
  owner 'root'
  group 'root'
  mode '0600'
  notifies :run, resources(:execute => 'preseed mysql-server'), :immediately
end

package 'mariadb-server-5.5'

include_recipe 'mysql::configuration'
include_recipe 'mysql::tuning'
include_recipe 'mysql::databases'

service 'mysql' do
	action [ :enable, :start ]
end
