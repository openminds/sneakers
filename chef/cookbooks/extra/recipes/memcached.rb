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
  notifies :restart, "service[memcached]"
end