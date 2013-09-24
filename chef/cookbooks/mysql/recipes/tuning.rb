include_recipe 'mysql::default'

template '/etc/mysql/conf.d/innodb_tuning.cnf' do
  source 'innodb_tuning.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[mysql]'
end
