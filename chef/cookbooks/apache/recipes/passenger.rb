include_recipe 'apache'

node[:apache][:passenger][:packages].each do |pkg|
  package pkg
end

gem_package 'passenger'
gem_package 'bundler'
gem_package 'sqlite3'

execute 'passenger-install-apache2-module' do
  command '/usr/bin/passenger-install-apache2-module --auto'
  not_if 'test -f /etc/apache2/mods-available/passenger.load'
end

template '/etc/apache2/mods-available/passenger.conf' do
  source 'passenger.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  not_if 'test -f /etc/apache2/mods-available/passenger.conf'
  variables passenger_snippet: node[:apache][:passenger][:snippet]
  notifies :restart, 'service[apache2]'
end

execute 'create the passenger.load file' do
  command 'passenger-install-apache2-module --snippet | grep LoadModule > /etc/apache2/mods-available/passenger.load'
  not_if 'test -f /etc/apache2/mods-available/passenger.load'
  notifies :restart, 'service[apache2]'
end

execute 'a2enmod passenger' do
  command 'a2enmod passenger'
  not_if 'test -e /etc/apache2/mods-enabled/passenger.load'
  notifies :restart, 'service[apache2]'
end

template '/etc/apache2/sites-available/default' do
  source 'rack_vhost.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[apache2]'
end
