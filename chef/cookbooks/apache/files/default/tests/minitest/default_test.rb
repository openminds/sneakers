class TestApache2 < MiniTest::Chef::TestCase
  def test_that_the_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/squeeze_openminds_apache.list")
  end

  def test_that_the_config_file_is_added
    assert File.exists?("/etc/apache2/apache2.conf")
  end

  def test_that_the_package_installed
    assert system('apt-cache policy apache2.2-common | grep Installed | grep -v none')
  end

  def test_that_the_service_is_running
    assert system('/etc/init.d/apache2 status')
  end

  def test_that_the_service_is_enabled
    assert File.exists?(Dir.glob("/etc/rc5.d/S*apache2").first)
  end
end
