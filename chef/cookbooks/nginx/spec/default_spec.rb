require 'spec_helper'

describe 'nginx::default' do
   let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {"app_directory"=>"/Users/zhann/Desktop/app1", "type"=>"php53", "http_port"=>8010, "memory"=>1024}
    end
    chef_run.converge 'nginx::default'
  }

  it 'includes nginx::configuration' do
    chef_run.should include_recipe "nginx::configuration"
  end

  it 'includes nginx::proxy' do
    chef_run.should include_recipe "nginx::proxy"
  end

  it 'installs nginx' do
    chef_run.should install_package 'nginx'
  end

  it 'sets service nginx with action nothing' do
    chef_run.should set_service_to_start_on_boot 'nginx'
    chef_run.should start_service 'nginx'
  end
end
