package "php5-xdebug"

template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  mode "0644"
  variables(
    :params => node['xdebug']
  )
end