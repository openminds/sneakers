include_recipe 'nginx'

directory '/etc/nginx/extra.d'
directory '/var/log/nginx/'

cookbook_file '/etc/nginx/mime.types' do
  source 'mime.types'
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  notifies :restart, 'service[nginx]'
end

cookbook_file '/etc/init.d/nginx' do
  source 'init.d-nginx'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :run, 'execute[Fix windows <CR>]', :immediately
  notifies :restart, 'service[nginx]'
end

execute 'Fix windows <CR>' do
  command "perl -i -pe's/\r$//;' /etc/init.d/nginx"
  action :nothing
end
