%w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty
  sudo build-essential xfsprogs ssh less psmisc rsync pwgen ntpdate ntp sysstat iotop git
  screen telnet debian-keyring aspell atop ffmpeg ghostscript imagemagick mysql-client ncftp
  slay swish-e bind9-host bc wget curl lynx git-core subversion mercurial bzr postfix].each do |pkg|
  package pkg
end
