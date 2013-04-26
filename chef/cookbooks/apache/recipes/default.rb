service "apache2"

include_recipe "apt"

apt_repository "squeeze_openminds_apache" do
  uri "http://debs.openminds.be"
  distribution node['lsb']['codename']
  components ["apache2"]
  key "http://debs.openminds.be/debs.openminds.key"
  action :add
end

%w[libcap2 apache2-mpm-worker libaprutil1-dbd-sqlite3 libaprutil1-dbd-mysql libaprutil1-dbd-odbc libaprutil1-dbd-pgsql libaprutil1-dbd-freetds libaprutil1-ldap libapache2-mod-rpaf apache2-suexec libapache2-mod-fastcgi].each do |pkg|
  package pkg
end

template "/etc/apache2/apache2.conf" do
  source "apache2.conf.erb"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[apache2]"
end

node['apache']['modules_enabled'].each do |mod|
  apache_module mod
end

apache_configuration "security"
apache_configuration "ports"
apache_configuration "nogit"

apache_configuration "fcgid" do
  is_module true
end

apache_module "status" do
  use_custom_configuration true # make /server-status work with Drupal setups
end

apache_module "setenvif"
apache_module "headers"
apache_module "ssl"

file "/usr/lib/apache2/suexec" do
  mode "4750"
end

cookbook_file "apache2-logrotate" do
  path "/etc/logrotate.d/apache2"
  source "apache2-logrotate"
end

directory "/home/vagrant/log/apache2/default" do
  recursive true
  mode 0755
end
