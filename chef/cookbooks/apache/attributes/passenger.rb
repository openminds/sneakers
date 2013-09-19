default[:apache][:passenger][:snippet] ||= %x[passenger-install-apache2-module --snippet | grep -v LoadModule]
