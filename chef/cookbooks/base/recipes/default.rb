include_recipe 'base::repositories'
include_recipe 'base::packages'

cookbook_file '/etc/mime.types' do
  source 'mime.types'
  owner 'root'
  group 'root'
  mode '0644'
end

cookbook_file '/etc/postfix/main.cf' do
  source 'main.cf'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[postfix]'
end

file node[:timezone][:tz_file] do
  owner 'root'
  group 'root'
  mode '0644'
  content node[:timezone][:zone]
  notifies :run, 'execute[update timezone]'
end

execute 'update timezone' do
  command 'dpkg-reconfigure -f noninteractive tzdata'
  action :nothing
end

service 'postfix' do
  action [ :enable, :start ]
end
