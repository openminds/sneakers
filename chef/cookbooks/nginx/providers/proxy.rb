action :create do
  confd_resource :create
  proxy_resource :create
end

action :remove do
  proxy_resource :delete
end

private

def confd_resource(exec_action)
  d = directory "/etc/nginx/conf.d" do
    action :nothing
  end
  d.run_action(exec_action)
end

def proxy_resource(exec_action)
  t = template "/etc/nginx/conf.d/#{new_resource.name}.conf" do
    cookbook 'nginx'
    source "proxy/vhost.conf.erb"
    owner "root"
    group "root"
    mode '0644'
    variables :name => new_resource.name,
      :servername => new_resource.servername,
      :serveraliases => new_resource.serveraliases,
      :user => new_resource.user
    action :nothing
  end

  t.run_action(exec_action)
  new_resource.updated_by_last_action(true) if t.updated_by_last_action?
end
