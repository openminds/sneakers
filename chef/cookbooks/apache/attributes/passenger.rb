default[:apache][:passenger][:snippet] = Mixlib::ShellOut.new("passenger-install-apache2-module --snippet | grep -v LoadModule")
default[:apache][:passenger][:packages] = %w[ libapr1-dev libaprutil1-dev libpq5 libcurl4-openssl-dev libxslt1-dev libxml2-dev apache2-prefork-dev dpatch libpcre3-dev sharutils libqt4-sql-sqlite libsqlite3-0 libsqlite3-dev ]
