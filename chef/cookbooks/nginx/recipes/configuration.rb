include_recipe 'nginx'


directory "/etc/nginx/extra.d"

cookbook_file "/etc/init.d/nginx" do
  source "init.d-nginx"
  mode "0755"
  owner "root"
  group "root"
  action :create
  notifies :start, "service[nginx]"
  notifies :run, "execute[Fix windows <CR>]"
end

cookbook_file "/etc/nginx/mime.types" do
  source "mime.types"
end

directory "/var/log/nginx/"

cookbook_file "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  notifies :restart, "service[nginx]"
end

execute "Fix windows <CR>" do
  command "perl -i -pe's/\r$//;' /etc/init.d/nginx"
  action :run
end
