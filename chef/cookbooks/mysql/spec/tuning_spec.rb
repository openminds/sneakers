require 'spec_helper'

describe 'mysql::tuning' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:memory][:total] = 1024
      node.set[:base][:name] = 'test'
    end
    chef_run.converge 'mysql::tuning'
  }

  it 'creates /etc/mysql/conf.d/innodb_tuning.cnf' do
    file = chef_run.template '/etc/mysql/conf.d/innodb_tuning.cnf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[mysql]', :restart
  end
end
