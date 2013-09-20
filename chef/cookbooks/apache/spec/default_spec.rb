require 'spec_helper'

describe 'apache::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {
        app_directory: '/Users/zhann/Desktop/app1',
        type: 'php53',
        http_port: 8010,
        memory: 1024
      }
    end
    chef_run.converge 'apache::default'
  }

  it 'sets apache2 service' do
    chef_run.should set_service_to_start_on_boot 'apache2'
    chef_run.should start_service 'apache2'
  end

  %w[libcap2 apache2-mpm-worker libaprutil1-dbd-sqlite3 libaprutil1-dbd-mysql libaprutil1-dbd-odbc libaprutil1-dbd-pgsql libaprutil1-dbd-freetds libaprutil1-ldap libapache2-mod-rpaf apache2-suexec libapache2-mod-fastcgi].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'creates /etc/apache2/apache2.conf' do
    chef_run.should create_file '/etc/apache2/apache2.conf'
    file = chef_run.template '/etc/apache2/apache2.conf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[apache2]', :restart
  end

  ["actions","alias","auth_basic","authn_file","authz_default","authz_groupfile","authz_host","authz_user","autoindex","cgid","deflate","dir","env","expires","fastcgi","headers","mime","negotiation","rewrite","rpaf","setenvif","suexec", 'security', 'ports', 'nogit', 'fcgid', 'status', 'ssl'].each do |mod|
    it "installs mod #{mod}" do
      pending "installs #{mod}"
    end
  end

  it 'creates /usr/lib/apache2/suexec' do
    chef_run.should create_file '/usr/lib/apache2/suexec'
    file = chef_run.file '/usr/lib/apache2/suexec'
    file.mode.should eq '4750'
  end

  it 'creates /etc/logrotate.d/apache2' do
    chef_run.should create_cookbook_file '/etc/logrotate.d/apache2'
  end

  it 'creates directory /home/vagrant/log/apache2/default' do
    chef_run.should create_directory '/home/vagrant/log/apache2/default'
    directory = chef_run.directory '/home/vagrant/log/apache2/default'
    directory.mode.should eq 0755
  end

  it 'creates directory /home/vagrant/error_document' do
    chef_run.should create_directory '/home/vagrant/error_document'
    directory = chef_run.directory '/home/vagrant/error_document'
    directory.mode.should eq 00755
    directory.should be_owned_by 'vagrant', 'vagrant'
    directory.recursive.should eq true
  end

  it 'creates /home/vagrant/error_document/index.html' do
    chef_run.should create_file '/home/vagrant/error_document/index.html'
    file = chef_run.template '/home/vagrant/error_document/index.html'
    file.should be_owned_by 'vagrant', 'vagrant'
    file.mode.should eq 00644
  end
end
