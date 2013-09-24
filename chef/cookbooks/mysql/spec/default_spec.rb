require 'spec_helper'

describe 'mysql::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:memory][:total] = 1024
      node.set[:base][:name] = 'test'
    end
    chef_run.converge 'mysql::default'
  }

  it 'creates /var/cache/local/preseeding directory' do
    directory = chef_run.directory '/var/cache/local/preseeding'
    directory.recursive.should eq true
  end

  it 'creates /var/cache/local/preseeding/mysql-server.seed' do
    file = chef_run.template '/var/cache/local/preseeding/mysql-server.seed'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0600'
    file.should notify 'execute[preseed mysql-server]', :run
  end

  it 'installs mariadb-server-5.5' do
    chef_run.should install_package 'mariadb-server-5.5'
  end

  it 'includes recipe mysql::configuration' do
    chef_run.should include_recipe 'mysql::configuration'
  end

  it 'includes recipe mysql::tuning' do
    chef_run.should include_recipe 'mysql::tuning'
  end

  it 'includes recipe mysql::databases' do
    chef_run.should include_recipe 'mysql::databases'
  end

  it 'sets mysql service' do
    chef_run.should set_service_to_start_on_boot 'mysql'
    chef_run.should start_service 'mysql'
  end
end
