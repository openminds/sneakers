require 'spec_helper'

describe 'mysql::databases' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {
        app_directory: '/Users/zhann/Desktop/app1',
        type: 'php53',
        http_port: 8010,
        memory: 1024
      }
      node.set[:base][:name] = 'test'
      node.set[:memory][:total] = 1024
    end
    chef_run.converge 'mysql::databases'
  }

  it 'creates database' do
    chef_run.should execute_command "mysql -e 'create database #{chef_run.node[:base][:name]}'"
  end

  it 'creates database user' do
    chef_run.should execute_command "mysql -e \"grant all on #{chef_run.node[:base][:name]}.* to '#{chef_run.node[:base][:name]}'@'%' identified by 'vagrant'\""
  end

  it 'creates database grants' do
    chef_run.should execute_command "mysql -e \"grant create view on #{chef_run.node[:base][:name]}.* to '#{chef_run.node[:base][:name]}'@'%' identified by 'vagrant'; grant show view on #{chef_run.node[:base][:name]}.* to '#{chef_run.node[:base][:name]}'@'%' identified by 'vagrant'\""
  end

  it 'allows remote access for mysql root user' do
    chef_run.should execute_command "mysql -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'vagrant' WITH GRANT OPTION\""
  end
end
