include_recipe 'mysql::default'

template 'dotmy.cnf for vagrant user' do
  path '/home/vagrant/.my.cnf'
  source 'dotmy.cnf.erb'
  mode '0600'
  user 'vagrant'
  group 'vagrant'
  variables rootpassword: node[:mysql][:mysql_root_pass]
  notifies :restart, 'service[mysql]'
end

template 'dotmy.cnf for root' do
  path '/root/.my.cnf'
  source 'dotmy.cnf.erb'
  user 'root'
  group 'root'
  mode '0600'
  variables rootpassword: node[:mysql][:mysql_root_pass]
  notifies :restart, 'service[mysql]'
end

cookbook_file 'my.cnf' do
  path '/etc/mysql/my.cnf'
  source 'my.cnf'
  user 'root'
  group 'root'
  mode '0600'
  notifies :restart, 'service[mysql]'
end
