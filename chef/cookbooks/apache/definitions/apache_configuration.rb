define :apache_configuration, :is_module => false do
  include_recipe "apache"

  @path = params[:is_module] ? "mods-available" : "conf.d"

  template "/etc/apache2/#{@path}/#{params[:name]}.conf" do
    source "modules/#{params[:name]}.conf.erb"
    notifies :restart, "service[apache2]"
    mode 0644
  end
end
