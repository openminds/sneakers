require 'spec_helper'

describe 'mysql::configuration' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:memory][:total] = 1024
      node.set[:base][:name] = 'test'
    end
    chef_run.converge 'mysql::configuration'
  }

  it 'creates .my.cnf for vagrant user' do
    file = chef_run.template 'dotmy.cnf for vagrant user'
    file.should be_owned_by 'vagrant', 'vagrant'
    file.mode.should eq '0600'
    file.should notify 'service[mysql]', :restart
  end

  it 'creates .my.cnf for root user' do
    file = chef_run.template 'dotmy.cnf for root'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0600'
    file.should notify 'service[mysql]', :restart
  end

  it 'creates /etc/mysql/my.cnf' do
    chef_run.should create_cookbook_file '/etc/mysql/my.cnf'
    file = chef_run.cookbook_file 'my.cnf'
    file.mode.should eq '0600'
    file.should notify 'service[mysql]', :restart
  end
end
