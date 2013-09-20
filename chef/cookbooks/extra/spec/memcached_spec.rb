require 'spec_helper'

describe 'extra::memcached' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {
        app_directory: '/Users/zhann/Desktop/app1',
        type: 'php53',
        http_port: 8010,
        memory: 1024
      }
    end
    chef_run.converge 'extra::memcached'
  }

  %w[ memcached php5-memcached ].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'creates /etc/memcached.conf' do
    file = chef_run.template '/etc/memcached.conf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[memcached]', :restart
  end

  it 'enabled memcached' do
    chef_run.should set_service_to_start_on_boot 'memcached'
    chef_run.should start_service 'memcached'
  end
end
