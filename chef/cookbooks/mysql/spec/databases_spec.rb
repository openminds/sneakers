require 'spec_helper'

describe 'mysql::databases' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
    chef_run.converge 'mysql::databases'
  }

  it 'creates database and user' do
    pending 'creates database and user'
  end

  it 'allows remote access for mysql root user' do
    pending 'allows remote access for mysql root user'
  end
end
