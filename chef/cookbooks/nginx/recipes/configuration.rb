directory "/etc/nginx/extra.d"

cookbook_file "/etc/init.d/nginx" do
  source "init.d-nginx"
  mode "0755"
  owner "root"
  action :create
  notifies :start, "service[nginx]"
end

cookbook_file "/etc/nginx/mime.types" do
  source "mime.types"
end

directory "/var/log/nginx/"

cookbook_file "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  notifies :restart, "service[nginx]"
end
