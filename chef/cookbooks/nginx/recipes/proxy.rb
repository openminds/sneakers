cookbook_file "/etc/nginx/proxy_vhost.conf" do
  source "proxy/vhost.conf"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/etc/nginx/extra.d/proxy.conf" do
  source "proxy/conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end
