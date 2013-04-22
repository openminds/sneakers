define :apache_module, :enable => true, :use_custom_configuration => false do
  include_recipe "apache"

  params[:filename] = params[:filename] || "mod_#{params[:name]}.so"
  params[:module_path] = params[:module_path] || "/usr/lib/apache2/#{params[:filename]}"

  if params[:use_custom_configuration]
    apache_configuration params[:name] do
      is_module true
    end
  end

  if params[:enable]
    execute "a2enmod #{params[:name]}" do
      command "/usr/sbin/a2enmod #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
      not_if do (::File.symlink?("/etc/apache2/mods-enabled/#{params[:name]}.load") and
        ((::File.exists?("/etc/apache2/mods-available/#{params[:name]}.conf"))?
          (::File.symlink?("/etc/apache2/mods-enabled/#{params[:name]}.conf")):(true)))
      end
    end
  else
    execute "a2dismod #{params[:name]}" do
      command "/usr/sbin/a2dismod #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
      only_if do ::File.symlink?("/etc/apache2/mods-enabled/#{params[:name]}.load") end
    end
  end
end
