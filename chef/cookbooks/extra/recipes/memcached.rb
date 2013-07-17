%w(memcached php5-memcached).each do |pkg|
  package pkg do
    action :install
  end
end