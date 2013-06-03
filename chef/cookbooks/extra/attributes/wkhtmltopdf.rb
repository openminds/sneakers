default[:wkhtmltopdf][:version] = '0.9.9'

if node[:kernel][:machine] == 'x86_64'
  default[:wkhtmltopdf][:arch] = 'amd64'
  default[:wkhtmltopdf][:checksum] = '7ddd09b0afeb'
else
  default[:wkhtmltopdf][:arch] = 'i386'
  default[:wkhtmltopdf][:checksum] = '44f1ae712f14'
end

default[:wkhtmltopdf][:static_download_url] = "http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-#{node[:wkhtmltopdf][:version]}-static-#{node[:wkhtmltopdf][:arch]}.tar.bz2"
default[:wkhtmltopdf][:binary_name] = "wkhtmltopdf-#{node[:wkhtmltopdf][:arch]}"
