require 'spec_helper'

describe 'base::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
    chef_run.converge 'base::default'
  }

  it 'creates empty main sources.list file' do
    file = chef_run.file '/etc/apt/sources.list'
    file.content.should eq '# Managed by chef'
  end

  it 'creates /etc/apt/sources.list.d/openminds_mirror.list' do
    file = chef_run.file '/etc/apt/sources.list.d/openminds_mirror.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://mirror.openminds.be/debian squeeze main contrib non-free'
  end

  it 'creates /etc/apt/sources.list.d/squeeze_security.list' do
    file = chef_run.file '/etc/apt/sources.list.d/squeeze_security.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://security.debian.org squeeze/updates main contrib non-free'
  end

  it 'creates /etc/apt/sources.list.d/openminds_apache.list' do
    file = chef_run.file '/etc/apt/sources.list.d/openminds_apache.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq "deb http://debs.openminds.be #{chef_run.node['lsb']['codename']} apache2"
    file.should notify 'execute[apt-key openminds_apache]', :run
  end

  it 'creates /etc/apt/sources.list.d/nginx.list' do
    file = chef_run.file '/etc/apt/sources.list.d/nginx.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://nginx.org/packages/debian squeeze nginx'
    file.should notify 'execute[apt-key nginx]', :run
  end

  it 'runs apt-get update' do
    chef_run.should execute_command 'apt-get update -y'
  end
end
