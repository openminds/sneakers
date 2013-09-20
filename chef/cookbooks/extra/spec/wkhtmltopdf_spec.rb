require 'spec_helper'

describe 'extra::wkhtmltopdf' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5') do |node|
      node.set[:base][:app_settings] = {
        app_directory: '/Users/zhann/Desktop/app1',
        type: 'php53',
        http_port: 8010,
        memory: 1024
      }
    end
    chef_run.converge 'extra::wkhtmltopdf'
  }

  %w[ libxrender1 libxext6 libfontconfig1 ].each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end

  it 'downloads wkhtmltopdf' do
    file = chef_run.remote_file File.join(Chef::Config[:file_cache_path], 'wkhtmltopdf.tar.bz2')
    file.action.should eq [ :create_if_missing ]
    file.source.should eq [ chef_run.node[:wkhtmltopdf][:static_download_url] ]
    file.checksum.should eq chef_run.node[:wkhtmltopdf][:checksum]
    file.mode.should eq '0644'
  end

  it 'extracts wkhtmltopdf' do
    chef_run.should execute_command "tar jxvf #{::File.join(Chef::Config[:file_cache_path], 'wkhtmltopdf.tar.bz2')} -C #{Chef::Config[:file_cache_path]}"
  end

  it 'copies wkhtmltopdf to /usr/local/bin' do
    chef_run.should execute_command "cp #{::File.join(Chef::Config[:file_cache_path], chef_run.node[:wkhtmltopdf][:binary_name])} /usr/local/bin/wkhtmltopdf"
  end
end
