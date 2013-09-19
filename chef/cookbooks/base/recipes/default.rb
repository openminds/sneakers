# include_recipe "apt"

file "/etc/apt/sources.list" do
  content "# Managed by chef"
end

file "/etc/apt/sources.list.d/squeeze_mirror_openminds_be-source.list" do
  owner "root"
  group "root"
  mode "0644"
  content "deb http://mirror.openminds.be/debian squeeze main contrib non-free"
end

file "/etc/apt/sources.list.d/squeeze_security-source.list" do
  owner "root"
  group "root"
  mode "0644"
  content "deb http://security.debian.org squeeze/updates main contrib non-free"
end

file "/etc/apt/sources.list.d/squeeze_openminds_apache-source.list" do
  owner "root"
  group "root"
  mode "0644"
  content "deb http://debs.openminds.be #{node['lsb']['codename']} apache2"
  notifies :run, 'execute[add debs.openminds.be key]'
end

execute "add debs.openminds.be key" do
  command 'wget -qO - http://debs.openminds.be/debs.openminds.key | apt-key add -'
  action :nothing
end

file "/etc/apt/sources.list.d/nginx-source.list" do
  owner "root"
  group "root"
  mode "0644"
  content "deb http://nginx.org/packages/debian squeeze nginx"
  notifies :run, 'execute[add nginx.org key]'
end

execute "add nginx.org key" do
  command 'wget -qO - http://nginx.org/packages/keys/nginx_signing.key | apt-key add -'
  action :nothing
end

if node[:php] and node[:php][:version]
  case node[:php][:version]
  when "php54"
    file "/etc/apt/sources.list.d/dotdeb-php54-source.list" do
      owner "root"
      group "root"
      mode "0644"
      content "deb http://packages.dotdeb.org #{node['lsb']['codename']+"-php54"} all"
      notifies :run, 'execute[add www.dotdeb.org key]'
    end
  when "php53"
    file "/etc/apt/sources.list.d/dotdeb-source.list" do
      owner "root"
      group "root"
      mode "0644"
      content "deb http://packages.dotdeb.org #{node['lsb']['codename']} all"
      notifies :run, 'execute[add www.dotdeb.org key]'
    end
  else
    raise "Unknown PHP version type. Was: #{node[:php][:version]}"
  end
end

execute "add www.dotdeb.org key" do
  command 'wget -qO - http://www.dotdeb.org/dotdeb.gpg | apt-key add -'
  action :nothing
end

file "/etc/apt/sources.list.d/mariadb-source.list" do
  owner "root"
  group "root"
  mode "0644"
  content "deb http://mirror2.hs-esslingen.de/mariadb/repo/5.5/debian squeeze main"
  notifies :run, 'execute[add mariadb key]'
end

execute "add mariadb key" do
  command 'apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 1BB943DB'
  action :nothing
end

execute "apt-get update -y"

# apt_repository "squeeze_mirror_openminds_be" do
#   uri "http://mirror.openminds.be/debian"
#   distribution "squeeze"
#   components ["main", "contrib", "non-free"]
#   action :add
# end

# apt_repository "squeeze_security" do
#   uri "http://security.debian.org"
#   distribution "squeeze/updates"
#   components ["main", "contrib", "non-free"]
#   action :add
# end

%w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty
  sudo build-essential xfsprogs ssh less psmisc rsync pwgen ntpdate ntp sysstat iotop git
  screen telnet debian-keyring aspell atop ffmpeg ghostscript imagemagick mysql-client ncftp
  slay swish-e bind9-host bc wget curl lynx git-core subversion mercurial bzr].each do |pkg|
  package pkg
end

cookbook_file "/etc/skel/.gemrc" do
  source "gemrc"
end

execute "update-tzdata" do
  command "dpkg-reconfigure -f noninteractive tzdata"
  action :nothing
end

file node[:timezone][:tz_file] do
  owner "root"
  group "root"
  mode "00644"
  content node[:timezone][:zone]
  notifies :run, "execute[update-tzdata]"
end

cookbook_file "/etc/mime.types" do
  source  "mime.types"
  owner  "root"
  group  "root"
  mode  0644
end

package "postfix"

cookbook_file "/etc/postfix/main.cf" do
  source "main.cf"
  owner "root"
  group "root"
  mode 00644
  notifies :restart, "service[postfix]"
end

service "postfix"
