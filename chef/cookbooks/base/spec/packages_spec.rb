require 'spec_helper'

describe 'base::default' do
  let(:chef_run) {
    chef_run = ChefSpec::ChefRunner.new(platform:'debian', version:'6.0.5')
    chef_run.converge 'base::default'
  }

  packages = %w[
    lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty
    sudo build-essential xfsprogs ssh less psmisc rsync pwgen ntpdate ntp sysstat iotop git
    screen telnet debian-keyring aspell atop ffmpeg ghostscript imagemagick mysql-client ncftp
    slay swish-e bind9-host bc wget curl lynx git-core subversion mercurial bzr
  ]

  packages.each do |pkg|
    it "installs #{pkg}" do
      chef_run.should install_package pkg
    end
  end
end
