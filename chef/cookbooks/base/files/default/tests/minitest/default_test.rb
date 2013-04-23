class TestBase < MiniTest::Chef::TestCase
  def test_that_the_om_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/squeeze_mirror_openminds_be.list")
  end

    def test_that_the_security_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/squeeze_security.list")
  end

  def test_that_the_mime_types_file_is_added
    assert File.exists?("/etc/mime.types")
  end

  def test_that_the_packages_are_installed
    %w[lsb lsb-release tzdata ncurses-term lsof strace snmpd locales vim bsd-mailx mingetty sudo build-essential xfsprogs ssh less psmisc rsync pwgen curl ntpdate ntp sysstat iotop git screen telnet debian-keyring].each do |pkg|
      assert system("apt-cache policy #{pkg} | grep Installed | grep -v none")
    end
  end
end
