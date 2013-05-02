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

template "/etc/nginx/conf.d/default.conf" do
  source "proxy/default.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :backend_port => 8080,
    :listen_port => node[:base][:app_settings].http_port.to_s
  )
  notifies :reload, "service[nginx]"
end
