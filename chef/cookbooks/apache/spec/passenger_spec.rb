require 'spec_helper'

describe 'apache::passenger' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
    	node.set[:base][:app_settings] = {"app_directory"=>"/Users/zhann/Desktop/app1", "type"=>"php53", "http_port"=>8010, "memory"=>1024}
    end
    chef_run.converge 'apache::passenger'
  }

  it 'installs passenger gem' do
    chef_run.should install_gem_package 'passenger'
  end

  %w[libapr1-dev libaprutil1-dev libpq5 libcurl4-openssl-dev libxslt1-dev libxml2-dev apache2-prefork-dev dpatch libaprutil1-dev libapr1-dev libpcre3-dev sharutils libaprutil1-dbd-sqlite3 libqt4-sql-sqlite libsqlite3-0 libsqlite3-dev].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'installs passenger sqlite3' do
    chef_run.should install_gem_package 'sqlite3'
  end

  it 'install libpq-dev' do
    chef_run.should install_package 'libpq-dev'
  end

  it 'should execute passenger-install-apache2-module' do
    chef_run.should execute_command '/usr/bin/passenger-install-apache2-module --auto'
  end

  it 'creates /etc/apache2/mods-available/passenger.conf' do
    chef_run.should create_file '/etc/apache2/mods-available/passenger.conf'
    file = chef_run.template '/etc/apache2/mods-available/passenger.conf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[apache2]', :restart
  end

  it 'should execute create the passenger.load file' do
    chef_run.should execute_command 'passenger-install-apache2-module --snippet | grep LoadModule > /etc/apache2/mods-available/passenger.load'
    exec = chef_run.execute 'create the passenger.load file'
    exec.should notify 'service[apache2]', :restart
  end

  it 'should execute a2enmod passenger' do
    chef_run.should execute_command 'a2enmod passenger'
    exec = chef_run.execute 'a2enmod passenger'
    exec.should notify 'service[apache2]', :restart
  end

  it 'should install bundler' do
    chef_run.should install_gem_package 'bundler'
  end

  it 'creates /etc/apache2/sites-available/default' do
    chef_run.should create_file '/etc/apache2/sites-available/default'
    file = chef_run.template '/etc/apache2/sites-available/default'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[apache2]', :restart
  end
end
