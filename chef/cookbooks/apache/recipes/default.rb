node[:apache][:packages].each do |pkg|
  package pkg
end

template '/etc/apache2/apache2.conf' do
  source 'apache2.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[apache2]'
end

node[:apache][:configs].each do |config|
  template "/etc/apache2/conf.d/#{config}.conf" do
    source "modules/#{config}.conf.erb"
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[apache2]'
  end
end

node[:apache][:mods].each do |mod|
  execute "a2enmod #{mod}" do
    notifies :restart, 'service[apache2]'
  end
end

file '/usr/lib/apache2/suexec' do
  mode '4750'
  notifies :restart, 'service[apache2]'
end

cookbook_file 'apache2-logrotate' do
  path '/etc/logrotate.d/apache2'
  source 'apache2-logrotate'
end

directory '/home/vagrant/log/apache2/default' do
  recursive true
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/home/vagrant/error_document' do
  recursive true
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
end

template '/home/vagrant/error_document/index.html' do
  source 'error.html.erb'
  owner 'vagrant'
  group 'vagrant'
  variables(
    :app_directory => node[:base][:app_settings].app_directory.to_s,
    :app_name => node[:base][:name]
  )
  mode '0644'
end

service 'apache2' do
  action [ :enable, :start ]
end
