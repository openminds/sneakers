require 'spec_helper'

describe 'phpmyadmin::default' do
   let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {"app_directory"=>"/Users/zhann/Desktop/app1", "type"=>"php53", "http_port"=>8010, "memory"=>1024}
    end
    chef_run.converge 'phpmyadmin::default'
  }

  it 'creates phpmyadmin users' do
    chef_run.should create_user('phpmyadmin').with(shell: '/bin/false')
  end

  it 'creates /home/phpmyadmin' do
    directory = chef_run.directory '/home/phpmyadmin/'
    directory.should be_owned_by 'phpmyadmin', 'phpmyadmin'
  end

  it 'downloads phpmyadmin' do
    chef_run.should create_remote_file '/tmp/phpMyAdmin-all-languages.tar.bz2'
  end

  it 'creates directory /home/phpmyadmin/default_www' do
    directory = chef_run.directory "/home/phpmyadmin/default_www"
    directory.should be_owned_by 'phpmyadmin', 'phpmyadmin'
    directory.mode.should eq '0755'
  end

  it 'extracts phpmyadmin' do
    chef_run.should execute_command 'tar xf /tmp/phpMyAdmin-all-languages.tar.bz2 -C /home/phpmyadmin/default_www; chown -Rf phpmyadmin:phpmyadmin /home/phpmyadmin/default_www'
  end

  it 'deletes directory /home/phpmyadmin/default_www/setup' do
    chef_run.should delete_directory "/home/phpmyadmin/default_www/setup"
  end

  it 'creates config.inc.php' do
    file = chef_run.template 'config.inc.php'
    file.should be_owned_by 'phpmyadmin', 'phpmyadmin'
    file.mode.should eq '0644'
  end
end
