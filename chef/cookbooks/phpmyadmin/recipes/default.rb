latest_version = '3.5.4'

user 'phpmyadmin' do
  comment 'phpmyadmin'
  shell '/bin/false'
end

directory '/home/phpmyadmin/' do
  owner 'phpmyadmin'
  group 'phpmyadmin'
end

remote_file '/tmp/phpMyAdmin-all-languages.tar.bz2' do
  source 'http://november.openminds.be/~steven/phpMyAdmin-3.5.4-all-languages.tar.bz2'
  not_if { ::File.exists? '/tmp/phpMyAdmin-all-languages.tar.bz2' }
end

directory '/home/phpmyadmin/default_www' do
  owner 'phpmyadmin'
  group 'phpmyadmin'
  mode '0755'
end

execute 'extract phpmyadmin' do
  command 'tar xf /tmp/phpMyAdmin-all-languages.tar.bz2 -C /home/phpmyadmin/default_www; chown -Rf phpmyadmin:phpmyadmin /home/phpmyadmin/default_www'
  not_if 'test -f /home/phpmyadmin/default_www/config.inc.php'
end

directory '/home/phpmyadmin/default_www/setup' do
  recursive true
  action :delete
end

template 'config.inc.php' do
  path '/home/phpmyadmin/default_www/config.inc.php'
  source 'config.inc.php.erb'
  owner 'phpmyadmin'
  group 'phpmyadmin'
  mode '0644'
  variables hash: Digest::SHA1.hexdigest((node[:hostname]+node[:ipaddress]).to_s)
end
