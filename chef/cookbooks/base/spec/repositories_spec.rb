require 'spec_helper'

describe 'base::default' do
  [ "6.0.5" "7.3" ].each do |debian_version|
    let(:chef_run) {
      chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:"#{debian_version}")
      chef_run.converge 'base::default'
    }
  end

  it 'creates empty main sources.list file' do
    file = chef_run.file '/etc/apt/sources.list'
    file.content.should eq '# Managed by chef'
  end

  it 'creates /etc/apt/sources.list.d/openminds_mirror.list' do
    file = chef_run.file '/etc/apt/sources.list.d/openminds_mirror.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq "deb http://mirror.openminds.be/debian #{chef_run.node['lsb']['codename']} main contrib non-free"
  end

  it 'creates /etc/apt/sources.list.d/debian_security.list' do
    file = chef_run.file '/etc/apt/sources.list.d/debian_security.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://security.debian.org squeeze/updates main contrib non-free'
  end

  it 'creates /etc/apt/sources.list.d/openminds_apache.list' do
    file = chef_run.file '/etc/apt/sources.list.d/openminds_apache.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq "deb http://debs.openminds.be #{chef_run.node['lsb']['codename']} apache2"
    file.should notify 'execute[apt-key openminds_apache]', :run, :immediately
  end

  it 'creates /etc/apt/sources.list.d/nginx.list' do
    file = chef_run.file '/etc/apt/sources.list.d/nginx.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://nginx.org/packages/debian squeeze nginx'
    file.should notify 'execute[apt-key nginx]', :run, :immediately
  end

  it 'creates /etc/apt/sources.list.d/dotdeb.list' do
    file = chef_run.file '/etc/apt/sources.list.d/dotdeb.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq "deb http://packages.dotdeb.org squeeze all"
    file.should notify 'execute[apt-key dotdeb]', :run, :immediately
  end

  it 'creates /etc/apt/sources.list.d/mariadb.list' do
    file = chef_run.file '/etc/apt/sources.list.d/mariadb.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://mirror2.hs-esslingen.de/mariadb/repo/5.5/debian squeeze main'
    file.should notify 'execute[apt-key mariadb]', :run, :immediately
  end

  context 'php54 installation' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
      runner.node.set[:php][:version] = 'php54'
      runner.converge('base::default')
    end

    it '/etc/apt/sources.list.d/dotdeb-php54.list' do
      file = chef_run.file '/etc/apt/sources.list.d/dotdeb-php54.list'
      file.mode.should eq '0644'
      file.should be_owned_by 'root', 'root'
      file.content.should eq "deb http://packages.dotdeb.org squeeze-php54 all"
      file.should notify 'execute[apt-key dotdeb]', :run, :immediately
    end
  end

  it '/etc/apt/preferences.d/dotdeb_php_pinning' do
    file = chef_run.template '/etc/apt/preferences.d/dotdeb_php_pinning'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
  end

  it 'runs apt-get update' do
    chef_run.should execute_command 'apt-get update -y'
  end
end
