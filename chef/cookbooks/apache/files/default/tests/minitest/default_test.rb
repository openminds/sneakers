class TestApache2 < MiniTest::Chef::TestCase
  def test_that_the_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/squeeze_openminds_apache.list")
  end

  def test_that_the_config_file_is_added
    assert File.exists?("/etc/apache2/apache2.conf")
  end

  def test_that_the_packages_are_installed
    %w[libcap2 apache2-mpm-worker libaprutil1-dbd-sqlite3 libaprutil1-dbd-mysql libaprutil1-dbd-odbc libaprutil1-dbd-pgsql libaprutil1-dbd-freetds libaprutil1-ldap libapache2-mod-rpaf apache2-suexec libapache2-mod-fastcgi].each do |pkg|
      #assert system("apt-cache policy #{pkg} | grep Installed | grep -v none")
      assert system("dpkg -l | grep #{pkg}")
    end
  end

  def test_that_modules_are_enabled
    node[:apache][:modules_enabled].each do |mod|
      assert system("apache2ctl -M | grep #{mod}_module")
    end
  end

  def test_that_the_service_is_running
    assert system('/etc/init.d/apache2 status')
  end

  def test_that_the_service_is_enabled
    assert File.exists?(Dir.glob("/etc/rc5.d/S*apache2").first)
  end

  def test_default_page
    assert Net::HTTP.get(URI('http://127.0.0.1:42'))
  end

  def test_sneakers_page
    assert Net::HTTP.get(URI("http://127.0.0.1:#{node[:base][:app_settings].http_port.to_s}/this_page_does_not_exist_ohzie2saeliiJahl")).to_s.include? "Sneakers"
  end
end
