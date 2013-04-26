raise "You can not use passenger recipe in conjunction with apache::php" if node.recipes.include? "apache::php"

gem_package "passenger"

%w[libapr1-dev libaprutil1-dev libpq5 libcurl4-openssl-dev libxslt1-dev libxml2-dev apache2-prefork-dev dpatch libaprutil1-dev libapr1-dev libpcre3-dev sharutils].each do |pkg|
 package pkg
end

package "libpq-dev" do
  options "-t squeeze-backports"
end

execute "passenger-install-apache2-module" do
  command "/usr/bin/passenger-install-apache2-module --auto "
  action :run
  not_if "test -f /etc/apache2/mods-available/passenger.load"
end

template "/etc/apache2/mods-available/passenger.conf" do
  source "passenger.conf.erb"
  mode "0644"
  owner "root"
  action :create
  not_if "test -f /etc/apache2/mods-available/passenger.conf"
  notifies :restart, "service[apache2]"
  variables(
    :passenger_snippet => %x[passenger-install-apache2-module --snippet | grep -v LoadModule]
  )
end

execute "create the passenger.load file" do
  command "passenger-install-apache2-module --snippet | grep LoadModule > /etc/apache2/mods-available/passenger.load"
  notifies :restart, "service[apache2]"
  action :run
  not_if "test -f /etc/apache2/mods-available/passenger.load"
end

execute "a2enmod passenger" do
  command "a2enmod passenger"
  action :run
  notifies :restart, "service[apache2]"
  not_if "test -e /etc/apache2/mods-enabled/passenger.load"
end

gem_package "bundler" do
  action :install
end
