require 'spec_helper'

describe 'base::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      #node.set[:base][:app_settings] = {"app_directory"=>"/Users/zhann/Desktop/app1", "type"=>"php53", "http_port"=>8010, "memory"=>1024}
    end
    chef_run.converge 'base::default'
  }

  it 'includes recipe apt' do
    chef_run.should include_recipe 'apt'
  end

  it 'creates /etc/apt/sources.list' do
    chef_run.should create_file_with_content '/etc/apt/sources.list', '# Managed by chef'
  end

  it 'sets apt repository for squeeze_mirror_openminds_be' do
    pending 'sets squeeze_mirror_openminds_be repo'
  end

  it 'sets apt repository for squeeze_security' do
    pending 'sets squeeze_security repo'
  end

%w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty
  sudo build-essential xfsprogs ssh less psmisc rsync pwgen ntpdate ntp sysstat iotop git
  screen telnet debian-keyring aspell atop ffmpeg ghostscript imagemagick mysql-client ncftp
  slay swish-e bind9-host bc wget curl lynx git-core subversion mercurial bzr].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'creates /etc/skel/.gemrc' do
    chef_run.should create_cookbook_file '/etc/skel/.gemrc'
  end

  it 'creates timezone file' do
    file = chef_run.file chef_run.node[:timezone][:tz_file]
    file.mode.should eq '00644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq chef_run.node[:timezone][:zone]
    file.should notify 'execute[update-tzdata]', :run
  end

  it 'creates /etc/mime.types' do
    chef_run.should create_cookbook_file '/etc/mime.types'
    file = chef_run.cookbook_file '/etc/mime.types'
    file.mode.should eq 00644
    file.should be_owned_by 'root', 'root'
  end

  it "installs postfix" do
    chef_run.should install_package 'postfix'
  end

  it 'creates /etc/postfix/main.cf' do
    chef_run.should create_cookbook_file '/etc/postfix/main.cf'
  end

  it 'sets postfix service' do
    pending 'sets postfix service'
  end
end

#   it 'sets apache2 service' do
#     chef_run.should set_service_to_start_on_boot 'apache2'
#   end

#   it 'includes recipe apt' do
#     chef_run.should include_recipe 'apt'
#   end

#   it 'sets apt repository for squeeze_openminds_apache' do
#     pending 'sets squeeze_openminds_apache repo'
#   end

#   %w[libcap2 apache2-mpm-worker libaprutil1-dbd-sqlite3 libaprutil1-dbd-mysql libaprutil1-dbd-odbc libaprutil1-dbd-pgsql libaprutil1-dbd-freetds libaprutil1-ldap libapache2-mod-rpaf apache2-suexec libapache2-mod-fastcgi].each do |pkg|
#     it "installs #{pkg}" do
#       chef_run.should install_package pkg
#     end
#   end

#   it 'creates /etc/apache2/apache2.conf' do
#     chef_run.should create_file '/etc/apache2/apache2.conf'
#     file = chef_run.template '/etc/apache2/apache2.conf'
#     file.should be_owned_by 'root', 'root'
#     file.mode.should eq '0644'
#     file.should notify 'service[apache2]', :restart
#   end

#   ["actions","alias","auth_basic","authn_file","authz_default","authz_groupfile","authz_host","authz_user","autoindex","cgid","deflate","dir","env","expires","fastcgi","headers","mime","negotiation","rewrite","rpaf","setenvif","suexec", 'security', 'ports', 'nogit', 'fcgid', 'status', 'ssl'].each do |mod|
#     it "installs mod #{mod}" do
#       pending "installs #{mod}"
#     end
#   end

#   it 'creates /usr/lib/apache2/suexec' do
#     chef_run.should create_file '/usr/lib/apache2/suexec'
#     file = chef_run.file '/usr/lib/apache2/suexec'
#     file.mode.should eq '4750'
#   end

#   it 'creates /etc/logrotate.d/apache2' do
#     chef_run.should create_cookbook_file '/etc/logrotate.d/apache2'
#   end

#   it 'creates directory /home/vagrant/log/apache2/default' do
#     chef_run.should create_directory '/home/vagrant/log/apache2/default'
#     directory = chef_run.directory '/home/vagrant/log/apache2/default'
#     directory.mode.should eq 0755
#   end

#   it 'creates directory /home/vagrant/error_document' do
#     chef_run.should create_directory '/home/vagrant/error_document'
#     directory = chef_run.directory '/home/vagrant/error_document'
#     directory.mode.should eq 00755
#     directory.should be_owned_by 'vagrant', 'vagrant'
#     directory.recursive.should eq true
#   end

#   it 'creates /home/vagrant/error_document/index.html' do
#     chef_run.should create_file '/home/vagrant/error_document/index.html'
#     file = chef_run.template '/home/vagrant/error_document/index.html'
#     file.should be_owned_by 'vagrant', 'vagrant'
#     file.mode.should eq 00644
#   end
