include_recipe "apache::php"

node.override[:php][:html_errors] = 'On'

package 'php5-xdebug'

directory '/etc/php5/mods-available' do
  owner 'root'
  group 'root'
  mode  '0755'
  recursive true
  action :create
end

template '/etc/php5/mods-available/xdebug.ini' do
  mode '0644'
  variables params: node[:xdebug]
  notifies :restart, "service[php5-fpm]"
end
