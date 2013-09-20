require 'spec_helper'

describe 'nginx::configuration' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {
        app_directory: '/Users/zhann/Desktop/app1',
        type: 'php53',
        http_port: 8010,
        memory: 1024
      }
    end
    chef_run.converge 'nginx::configuration'
  }

  it 'creates /etc/nginx/extra.d directory' do
    chef_run.should create_directory '/etc/nginx/extra.d'
  end

  it 'sets nginx init file' do
    file = chef_run.cookbook_file '/etc/init.d/nginx'
    file.mode.should eq '0755'
    file.should be_owned_by 'root', 'root'
    file.should notify 'service[nginx]', :start
    file.should notify 'execute[Fix windows <CR>]', :run
  end

  it 'creates /etc/nginx/mime.types' do
    chef_run.should create_file '/etc/nginx/mime.types'
  end

  it 'creates /var/log/nginx/' do
    chef_run.should create_directory '/var/log/nginx/'
  end

  it 'creates /etc/nginx/mime.types' do
    file = chef_run.cookbook_file '/etc/nginx/nginx.conf'
    file.should notify 'service[nginx]', :restart
  end

  it 'fixes windows end of lines' do
    chef_run.should execute_command "perl -i -pe's/\r$//;' /etc/init.d/nginx"
  end
end
