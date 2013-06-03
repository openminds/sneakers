cache_dir = Chef::Config[:file_cache_path]
download_dest = File.join(cache_dir, "wkhtmltopdf.tar.bz2")
binary_name = node[:wkhtmltopdf][:binary_name]

# install dependencies
%w(libxrender1 libxext6 libfontconfig1).each do |pkg|
  package pkg do
    action :install
  end
end

remote_file download_dest do
  source node[:wkhtmltopdf][:static_download_url]
  mode '0644'
  checksum node[:wkhtmltopdf][:checksum]
  action :create_if_missing
end

execute "Extract #{download_dest}" do
  command <<-COMMAND
    tar jxvf #{download_dest} -C #{cache_dir}
  COMMAND
  creates File.join(cache_dir, binary_name)
end

execute "Copy #{binary_name} to /usr/local/bin" do
  command <<-COMMAND
    cp #{File.join(cache_dir, binary_name)} /usr/local/bin/wkhtmltopdf
  COMMAND
  creates '/usr/local/bin/wkhtmltopdf'
end
