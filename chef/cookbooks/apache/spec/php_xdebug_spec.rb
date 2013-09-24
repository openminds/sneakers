require 'spec_helper'

describe 'apache::php_xdebug' do
   let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {"app_directory"=>"/Users/zhann/Desktop/app1", "type"=>"php53", "http_port"=>8010, "memory"=>1024}
    end
    chef_run.converge 'apache::php_xdebug'
  }

  it 'includes apache::php recipe' do
    chef_run.should include_recipe 'apache::php'
  end

  it 'installs php5-xdebug' do
    chef_run.should install_package 'php5-xdebug'
  end

  it 'creates /etc/php5/mods-available/xdebug.ini' do
    file = chef_run.template '/etc/php5/mods-available/xdebug.ini'
    file.should notify 'service[php5-fpm]', :restart
  end
end
