def documentroot_suffix
  if node[:base][:app_settings].attribute? 'documentroot_suffix'
    node[:base][:app_settings].documentroot_suffix.to_s
  else
    ''
  end
end
