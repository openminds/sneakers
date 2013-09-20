file '/etc/apt/sources.list' do
  content '# Managed by chef'
end

repositories = {
  'openminds_mirror' => 'deb http://mirror.openminds.be/debian squeeze main contrib non-free',
  'squeeze_security' => 'deb http://security.debian.org squeeze/updates main contrib non-free',
  'openminds_apache' => 'deb http://debs.openminds.be squeeze apache2',
  'nginx' => 'deb http://nginx.org/packages/debian squeeze nginx',
  'dotdeb' => "deb http://packages.dotdeb.org squeeze#{node[:php] && node[:php][:version] == 'php54' ? '-php54' : ''} all",
  'mariadb' => 'deb http://mirror2.hs-esslingen.de/mariadb/repo/5.5/debian squeeze main'
}

apt_keys = {
  'openminds_apache' => 'wget -qO - http://debs.openminds.be/debs.openminds.key | apt-key add -',
  'nginx' => 'wget -qO - http://nginx.org/packages/keys/nginx_signing.key | apt-key add -',
  'dotdeb' => 'wget -qO - http://www.dotdeb.org/dotdeb.gpg | apt-key add -',
  'mariadb' => 'apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1BB943DB'
}

repositories.each do |key, value|
  file "/etc/apt/sources.list.d/#{key}.list" do
    owner 'root'
    group 'root'
    mode '0644'
    content value
    notifies :run, "execute[apt-key #{key}]", :immediately if apt_keys.include? key
  end
end

apt_keys.each do |key, command|
  execute "apt-key #{key}" do
    command command
    action :nothing
  end
end

template '/etc/apt/preferences.d/dotdeb_php_pinning' do
  source 'dotdeb_php_pinning.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'apt-get update -y'
