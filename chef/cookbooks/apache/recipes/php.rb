include_recipe 'apache'

node[:php][:packages].each do |pkg|
  package pkg
end

directory '/etc/php5/mods-available' do
  owner 'root'
  group 'root'
  mode  '0755'
  recursive true
  action :create
end

file '/etc/php5/conf.d/suhosin.ini' do
  action :delete
end

file '/etc/php5/conf.d/timezone.ini' do
  owner 'root'
  group 'root'
  mode '0644'
  content "[Date]\ndate.timezone = '#{node[:php][:timezone]}'\n"
  action :create_if_missing
end

file '/etc/php5/conf.d/sessions-gc.ini' do
  owner 'root'
  group 'root'
  mode '0644'
  content "[Sessions]\nsession.gc_probability = 1\nsession.gc_divisor = 100"
  action :create_if_missing
end

file '/etc/apache2/conf.d/php-fpm-fcgi-servers' do
  owner 'root'
  group 'root'
  mode '0644'
  content 'FastCGIExternalServer /usr/sbin/php-fpm-vagrant -socket /var/run/php_fpm_vagrant.sock -idle-timeout 600 -pass-header Authorization'
  notifies :restart, 'service[apache2]'
end

cookbook_file '/etc/php5/fpm/pool.d/vagrant.conf' do
  source 'fpm-pool.conf'
  notifies :restart, 'service[php5-fpm]'
end

template '/etc/php5/mods-available/apc.ini' do
  source 'apc.ini.erb'
  mode '0644'
  notifies :restart, 'service[php5-fpm]'
end

template '/etc/apache2/sites-available/default' do
  source 'php_vhost.conf.erb'
  variables(
    port: 42,
    document_root: ::File.join('/home/vagrant/apps/default', documentroot_suffix)
  )
  notifies :restart, 'service[apache2]'
end

%w[ cli fpm ].each do |type|
  template "/etc/php5/#{type}/php.ini" do
    source 'php.ini.erb'
    owner 'root'
    group 'root'
    mode '0644'
    notifies :restart, 'service[php5-fpm]'
  end
end

execute 'install drush' do
  command 'pear channel-discover pear.drush.org && pear install drush/drush && /usr/bin/drush'
  creates '/usr/bin/drush'
end

service 'php5-fpm' do
  action [ :enable, :start ]
end
