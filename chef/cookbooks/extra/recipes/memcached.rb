%w[ memcached php5-memcached ].each do |pkg|
  package pkg
end

template '/etc/memcached.conf' do
  source 'memcached.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    listen: node[:memcached][:listen],
    user: node[:memcached][:user],
    port: node[:memcached][:port],
    maxconn: node[:memcached][:maxconn],
    memory: node[:memcached][:memory]
  )
  notifies :restart, 'service[memcached]'
end

service 'memcached' do
  action [ :enable, :start ]
end
