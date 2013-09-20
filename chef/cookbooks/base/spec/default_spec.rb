require 'spec_helper'

describe 'base::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
    chef_run.converge 'base::default'
  }

  it 'includes base::repositories' do
    chef_run.should include_recipe "base::repositories"
  end

  it 'includes base::packages' do
    chef_run.should include_recipe "base::packages"
  end

  it 'creates /etc/mime.types' do
    chef_run.should create_cookbook_file '/etc/mime.types'
    file = chef_run.cookbook_file '/etc/mime.types'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
  end

  it 'creates /etc/postfix/main.cf' do
    chef_run.should create_cookbook_file '/etc/postfix/main.cf'
  end

  it 'creates timezone file' do
    file = chef_run.file chef_run.node[:timezone][:tz_file]
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq chef_run.node[:timezone][:zone]
    file.should notify 'execute[update timezone]', :run
  end

  it 'sets postfix service' do
    chef_run.should set_service_to_start_on_boot 'postfix'
  end
end
