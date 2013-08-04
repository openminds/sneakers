template "dotmy.cnf for vagrant user" do
  path "/home/vagrant/.my.cnf"
  source "dotmy.cnf.erb"
  mode "0600"
  user "vagrant"
  group "vagrant"
  action :create
  variables(
          :rootpassword => node['mysql']['mysql_root_pass']
  )
  notifies :restart, "service[mysql]"
end

template "dotmy.cnf for root" do
  path "/root/.my.cnf"
  source "dotmy.cnf.erb"
  mode "0600"
  user "root"
  group "root"
  action :create
  variables(
          :rootpassword => node['mysql']['mysql_root_pass']
  )
  notifies :restart, "service[mysql]"
end

cookbook_file "my.cnf" do
  path "/etc/mysql/my.cnf"
  source "my.cnf"
  mode "0600"
  action :create
  notifies :restart, "service[mysql]"
end
