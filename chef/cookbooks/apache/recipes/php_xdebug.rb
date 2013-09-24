include_recipe "apache::php"

node.override[:php][:html_errors] = 'On'

package 'php5-xdebug'

template '/etc/php5/mods-available/xdebug.ini' do
  mode '0644'
  variables params: node[:xdebug]
  notifies :restart, "service[php5-fpm]"
end
