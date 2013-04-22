%w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty sudo build-essential xfsprogs ssh less psmisc rsync pwgen curl ntpdate ntp sysstat iotop git screen telnet debian-keyring].each do |pkg|
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
