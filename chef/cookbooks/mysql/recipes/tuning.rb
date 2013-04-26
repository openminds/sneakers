node.set["mysql"]["innodb_buffer_pool_size"] = (node["memory"]["total"].to_i / 3 / 1024).to_s + "M" unless node["mysql"].attribute? 'innodb_buffer_pool_size'

template "/etc/mysql/conf.d/innodb_tuning.cnf" do
  source "innodb_tuning.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[mysql]"
end
