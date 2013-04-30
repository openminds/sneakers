include_recipe "apt"

file "/etc/apt/sources.list" do
  content "# Managed by chef"
end

apt_repository "squeeze_mirror_openminds_be" do
  uri "http://mirror.openminds.be/debian"
  distribution "squeeze"
  components ["main", "contrib", "non-free"]
  action :add
end

apt_repository "squeeze_security" do
  uri "http://security.debian.org"
  distribution "squeeze/updates"
  components ["main", "contrib", "non-free"]
  action :add
end

%w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty sudo build-essential xfsprogs ssh less psmisc rsync pwgen curl ntpdate ntp sysstat iotop git screen telnet debian-keyring
  aspell atop ffmpeg ghostscript imagemagick mysql-client ncftp slay strace swish-e
  bind9-host bc wget curl lynx screen git-core subversion mercurial bzr].each do |pkg|
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
