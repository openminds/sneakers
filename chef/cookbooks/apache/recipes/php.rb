include_recipe "apt"

service "apache2"
service "php5-fpm"

case node[:php][:version]
when "5.4"
  apt_repository "dotdeb-php54" do
    uri "http://packages.dotdeb.org"
    distribution node['lsb']['codename']+"-php54"
    components ["all"]
    key "http://www.dotdeb.org/dotdeb.gpg"
    action :add
    notifies :run, "execute[apt-update]"
  end
else
  apt_repository "dotdeb" do
    uri "http://packages.dotdeb.org"
    distribution node['lsb']['codename']
    components ["all"]
    key "http://www.dotdeb.org/dotdeb.gpg"
    action :add
  end
end

cookbook_file "/etc/apt/preferences.d/dotdeb_php_pinning" do
  source "dotdeb_php_pinning"
  mode "0644"
  owner "root"
  action :create
end

%w[php5-cli php5-common php5-fpm php5-curl php5-dev php5-gd php5-imagick php5-imap php5-mcrypt php5-mysql php5-xmlrpc php-pear php5-intl php5-apc].each do |pkg|
  package pkg
end

template "/etc/php5/conf.d/apc.ini" do
  source "apc.ini.erb"
  mode "0644"
  action :create
  notifies :restart, "service[php5-fpm]"
end

file "/etc/php5/conf.d/suhosin.ini" do
  action :delete
end

file "/etc/php5/conf.d/timezone.ini" do
  owner "root"
  group "root"
  mode "0644"
  content "[Date]\ndate.timezone = '#{node["php"]["timezone"]}'\n"
  action :create_if_missing
end

file "/etc/php5/conf.d/sessions-gc.ini" do
  owner "root"
  group "root"
  mode "0644"
  content "[Sessions]\nsession.gc_probability = 1\nsession.gc_divisor = 100"
  action :create_if_missing
end

%w(cli fpm).each do |type|
  cookbook_file "/etc/php5/#{type}/php.ini" do
    source "php.ini"
    owner "root"
    group "root"
    mode "0644"
    notifies :reload, "service[php5-fpm]"
  end
end
