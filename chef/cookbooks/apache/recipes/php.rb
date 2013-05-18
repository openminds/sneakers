raise "You can not use php recipe in conjunction with apache::passenger" if node.recipes.include? "apache::passenger"

include_recipe "apt"

service "apache2"
service "php5-fpm"

case node[:php][:version]
when "php54"
  apt_repository "dotdeb-php54" do
    uri "http://packages.dotdeb.org"
    distribution node['lsb']['codename']+"-php54"
    components ["all"]
    key "http://www.dotdeb.org/dotdeb.gpg"
    action :add
  end
when "php53"
  apt_repository "dotdeb" do
    uri "http://packages.dotdeb.org"
    distribution node['lsb']['codename']
    components ["all"]
    key "http://www.dotdeb.org/dotdeb.gpg"
    action :add
  end
else
  raise "Unknown PHP version type. Was: #{node[:php][:version]}"
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

template "/etc/php5/conf.d/20-apc.ini" do
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
  template "/etc/php5/#{type}/php.ini" do
    source "php.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[php5-fpm]"
  end
end

template "/etc/apache2/sites-available/default" do
  source "php_vhost.conf.erb"
  variables(
    :port => 42,
    :document_root => ::File.join('/home/vagrant/apps/default', documentroot_suffix)
  )
  notifies :restart, "service[apache2]"
end

cookbook_file "/etc/php5/fpm/pool.d/vagrant.conf" do
  source "fpm-pool.conf"
  notifies :restart, "service[php5-fpm]"
end

file "/etc/apache2/conf.d/php-fpm-fcgi-servers" do
  action :create
  owner "root"
  group "root"
  mode 00644
  content "FastCGIExternalServer /usr/sbin/php-fpm-vagrant -socket /var/run/php_fpm_vagrant.sock -idle-timeout 600 -pass-header Authorization"
  notifies :restart, "service[apache2]"
end

execute "install drush" do
  command "pear channel-discover pear.drush.org && pear install drush/drush && /usr/bin/drush"
  creates "/usr/bin/drush"
end
