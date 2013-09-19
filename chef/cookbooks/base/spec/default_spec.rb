require 'spec_helper'

describe 'base::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
    chef_run.converge 'base::default'
  }

  it 'creates /etc/apt/sources.list' do
    chef_run.should create_file_with_content '/etc/apt/sources.list', '# Managed by chef'
  end

  it 'creates /etc/apt/sources.list.d/squeeze_mirror_openminds_be-source.list' do
    file = chef_run.file '/etc/apt/sources.list.d/squeeze_mirror_openminds_be-source.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://mirror.openminds.be/debian squeeze main contrib non-free'
  end

  it 'creates /etc/apt/sources.list.d/squeeze_security-source.list' do
    file = chef_run.file '/etc/apt/sources.list.d/squeeze_security-source.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://security.debian.org squeeze/updates main contrib non-free'
  end

  it 'creates /etc/apt/sources.list.d/squeeze_openminds_apache-source.list' do
    file = chef_run.file '/etc/apt/sources.list.d/squeeze_openminds_apache-source.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq "deb http://debs.openminds.be #{chef_run.node['lsb']['codename']} apache2"
    file.should notify 'execute[add debs.openminds.be key]', :run
  end

  it 'creates /etc/apt/sources.list.d/nginx-source.list' do
    file = chef_run.file '/etc/apt/sources.list.d/nginx-source.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://nginx.org/packages/debian squeeze nginx'
    file.should notify 'execute[add nginx.org key]', :run
  end

  context 'php54 installation' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
      runner.node.set[:php][:version] = 'php54'
      runner.converge('base::default')
    end

    it 'creates /etc/apt/sources.list.d/dotdeb-php54-source.list' do
      file = chef_run.file '/etc/apt/sources.list.d/dotdeb-php54-source.list'
      file.mode.should eq '0644'
      file.should be_owned_by 'root', 'root'
      file.content.should eq "deb http://packages.dotdeb.org squeeze-php54 all"
      file.should notify 'execute[add www.dotdeb.org key]', :run
    end
  end

  context 'php53 installation' do
    let(:chef_run) do
      runner = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
      runner.node.set[:php][:version] = 'php53'
      runner.converge('base::default')
    end

    it 'creates /etc/apt/sources.list.d/dotdeb-source.list' do
      file = chef_run.file '/etc/apt/sources.list.d/dotdeb-source.list'
      file.mode.should eq '0644'
      file.should be_owned_by 'root', 'root'
      file.content.should eq "deb http://packages.dotdeb.org squeeze all"
      file.should notify 'execute[add www.dotdeb.org key]', :run
    end
  end

  it 'creates /etc/apt/sources.list.d/mariadb-source.list' do
    file = chef_run.file '/etc/apt/sources.list.d/mariadb-source.list'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'deb http://mirror2.hs-esslingen.de/mariadb/repo/5.5/debian squeeze main'
    file.should notify 'execute[add mariadb key]', :run
  end

  it 'runs apt-get update' do
    chef_run.should execute_command 'apt-get update -y'
  end

%w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty
  sudo build-essential xfsprogs ssh less psmisc rsync pwgen ntpdate ntp sysstat iotop git
  screen telnet debian-keyring aspell atop ffmpeg ghostscript imagemagick mysql-client ncftp
  slay swish-e bind9-host bc wget curl lynx git-core subversion mercurial bzr].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'creates /etc/skel/.gemrc' do
    chef_run.should create_cookbook_file '/etc/skel/.gemrc'
  end

  it 'creates timezone file' do
    file = chef_run.file chef_run.node[:timezone][:tz_file]
    file.mode.should eq '00644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq chef_run.node[:timezone][:zone]
    file.should notify 'execute[update-tzdata]', :run
  end

  it 'creates /etc/mime.types' do
    chef_run.should create_cookbook_file '/etc/mime.types'
    file = chef_run.cookbook_file '/etc/mime.types'
    file.mode.should eq 00644
    file.should be_owned_by 'root', 'root'
  end

  it "installs postfix" do
    chef_run.should install_package 'postfix'
  end

  it 'creates /etc/postfix/main.cf' do
    chef_run.should create_cookbook_file '/etc/postfix/main.cf'
  end

  it 'sets postfix service' do
    pending 'sets postfix service'
  end
end
