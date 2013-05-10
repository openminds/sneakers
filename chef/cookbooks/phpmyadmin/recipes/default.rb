latest_version = "3.5.4"
service "apache2"
service "php5-fpm"

if (%x[egrep -i "^phpmyadmin" /etc/group].empty? == true) && (%x[grep phpmyadmin /etc/group].empty? == false)
  raise "phpmyadmin cookbook was refactored. Please do `deluser phpmyadmin` and rerun OR remove phpmyadmin cookbook from runlist. -Steven"
end

user "phpmyadmin" do
  comment "phpmyadmin"
  shell "/bin/false"
end

directory "/home/phpmyadmin/" do
  owner "phpmyadmin"
  group "phpmyadmin"
  recursive true
end

remote_file "/tmp/phpMyAdmin-all-languages.tar.bz2" do
  source "http://november.openminds.be/~steven/phpMyAdmin-3.5.4-all-languages.tar.bz2"
  not_if { ::File.exists? "/tmp/phpMyAdmin-all-languages.tar.bz2" }
end

directory "/home/phpmyadmin/default_www" do
  owner "phpmyadmin"
  group "phpmyadmin"
  mode 00755
  action :create
end

execute "extract phpmyadmin" do
  command "tar xf /tmp/phpMyAdmin-all-languages.tar.bz2 -C /home/phpmyadmin/default_www; chown -Rf phpmyadmin:phpmyadmin /home/phpmyadmin/default_www"
  not_if "test -f /home/phpmyadmin/default_www/config.inc.php"
end

directory "/home/phpmyadmin/default_www/setup" do
  recursive true
  action :delete #setup is dangerous, remove if found!
end

template "config.inc.php" do
  path "/home/phpmyadmin/default_www/config.inc.php"
  source "config.inc.php.erb"
  variables(
  :hash => Digest::SHA1.hexdigest((node[:hostname]+node[:ipaddress]).to_s)
  )
  owner "phpmyadmin"
  mode "0644"
end
