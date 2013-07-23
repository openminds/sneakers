%w(memcached php5-memcached).each do |pkg|
  package pkg do
    action :install
  end
end

service "memcached" do
  action :nothing
  supports :status => true, :start => true, :stop => true, :restart => true
end

template "/etc/memcached.conf" do
  source "memcached.conf.erb"
  owner "root"
  group "root"
  mode 00644
  variables(
    :listen => node['memcached']['listen'],
    :user => node['memcached']['user'],
    :port => node['memcached']['port'],
    :maxconn => node['memcached']['maxconn'],
    :memory => node['memcached']['memory']
  )
  notifies :restart, "service[memcached]"
end