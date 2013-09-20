require 'spec_helper'

describe 'apache::php' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {
        app_directory: '/Users/zhann/Desktop/app1',
        type: 'php53',
        http_port: 8010,
        memory: 1024
      }
    end
    chef_run.converge 'apache::php'
  }

  it 'includes recipe apache::default' do
    chef_run.should include_recipe 'apache::default'
  end

  %w[
    php5-cli php5-common php5-fpm php5-curl php5-dev php5-gd php5-imagick
    php5-imap php5-mcrypt php5-mysql php5-xmlrpc php-pear php5-intl php5-apc
  ].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'deletes /etc/php5/conf.d/suhosin.ini' do
    chef_run.should delete_file '/etc/php5/conf.d/suhosin.ini'
  end

  it 'creates /etc/php5/conf.d/timezone.ini' do
    file = chef_run.file '/etc/php5/conf.d/timezone.ini'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.content.should eq "[Date]\ndate.timezone = '#{chef_run.node["php"]["timezone"]}'\n"
  end

  it 'creates /etc/php5/conf.d/sessions-gc.ini' do
    file = chef_run.file '/etc/php5/conf.d/sessions-gc.ini'
    file.should be_owned_by 'root', 'root'
    file.mode.should eq '0644'
    file.content.should eq "[Sessions]\nsession.gc_probability = 1\nsession.gc_divisor = 100"
  end

  it "creates /etc/apache2/conf.d/php-fpm-fcgi-servers" do
    file = chef_run.file '/etc/apache2/conf.d/php-fpm-fcgi-servers'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.content.should eq 'FastCGIExternalServer /usr/sbin/php-fpm-vagrant -socket /var/run/php_fpm_vagrant.sock -idle-timeout 600 -pass-header Authorization'
    file.should notify 'service[apache2]', :restart
  end

  it "creates /etc/php5/fpm/pool.d/vagrant.conf" do
    file = chef_run.cookbook_file "/etc/php5/fpm/pool.d/vagrant.conf"
    file.should notify 'service[php5-fpm]', :restart
  end

  it 'sets fcgid in mods-available' do
    file = chef_run.template '/etc/apache2/mods-available/fcgid.conf'
    file.mode.should eq '0644'
    file.should be_owned_by 'root', 'root'
    file.should notify 'service[apache2]', :restart
    file.should notify 'execute[a2enmod fcgid]', :run
  end

  it 'creates /etc/php5/conf.d/20-apc.ini' do
    file = chef_run.template '/etc/php5/conf.d/20-apc.ini'
    file.should notify 'service[php5-fpm]', :restart
  end

  it "creates /etc/apache2/sites-available/default" do
    file = chef_run.template "/etc/apache2/sites-available/default"
    file.should notify 'service[apache2]', :restart
  end

  %w[ cli fpm ].each do |type|
    it "creates /etc/php5/#{type}/php.ini" do
      file = chef_run.template "/etc/php5/#{type}/php.ini"
      file.should be_owned_by 'root', 'root'
      file.mode.should eq '0644'
      file.should notify 'service[php5-fpm]', :restart
    end
  end

  it 'executes install drush' do
    chef_run.should execute_command 'pear channel-discover pear.drush.org && pear install drush/drush && /usr/bin/drush'
  end

  it 'sets php5-fpm service' do
    chef_run.should set_service_to_start_on_boot 'php5-fpm'
  end
end
