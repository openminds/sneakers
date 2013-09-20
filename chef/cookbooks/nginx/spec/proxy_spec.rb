require 'spec_helper'

describe 'nginx::proxy' do
   let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {"app_directory"=>"/Users/zhann/Desktop/app1", "type"=>"php53", "http_port"=>8010, "memory"=>1024}
    end
    chef_run.converge 'nginx::proxy'
  }

  it 'includes nginx::default' do
    chef_run.should include_recipe 'nginx::default'
  end

  it 'creates /etc/nginx/proxy_vhost.conf' do
    file = chef_run.cookbook_file '/etc/nginx/proxy_vhost.conf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[nginx]', :restart
  end

  it 'creates /etc/nginx/extra.d/proxy.conf' do
    file = chef_run.template '/etc/nginx/extra.d/proxy.conf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[nginx]', :restart
  end

  it 'creates /etc/nginx/conf.d/default.conf' do
    file = chef_run.template '/etc/nginx/conf.d/default.conf'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.should notify 'service[nginx]', :restart
  end
end
