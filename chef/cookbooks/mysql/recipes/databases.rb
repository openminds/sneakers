execute "create db" do
  command "mysql -e 'create database #{node[:base][:name]}'"
  not_if "mysql -e \"show databases\" | grep #{node[:base][:name]}"
end

execute "create db user" do
  command "mysql -e 'grant all on #{node[:base][:name]}.* to #{node[:base][:name]}@\'%\' identified by \'vagrant\''"
  not_if "mysql -e \"select * from mysql.user\" | grep % | grep vagrant"
end

execute "set db grants" do
  command "mysql -e 'grant create view on #{node[:base][:name]}.* to #{node[:base][:name]}@\'%\' identified by \'vagrant\'; grant show view on #{node[:base][:name]}.* to #{node[:base][:name]}@\'%\' identified by \'vagrant\''"
  not_if "mysql -e \"select * from mysql.user\" | grep % | grep vagrant"
end

execute "allow remote access for mysql root user" do
  command "mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION;\""
  not_if "mysql -e \"select * from mysql.user\" | grep % | grep root"
end
