class TestPhp < MiniTest::Chef::TestCase
  def test_that_the_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/dotdeb.list")
    assert File.exists?("/etc/apt/preferences.d/dotdeb_php_pinning")
  end

  def test_that_the_config_files_are_added
    assert File.exists?("/etc/php5/cli/php.ini")
    assert File.exists?("/etc/php5/fpm/php.ini")
    assert File.exists?("/etc/php5/conf.d/apc.ini")
  end

  def test_that_the_packages_are_installed
    %w[php5-cli php5-common php5-fpm php5-curl php5-dev php5-gd php5-imagick php5-imap php5-mcrypt php5-mysql php5-xmlrpc php-pear php5-intl php5-apc].each do |pkg|
      assert system("dpkg -l | grep #{pkg}")
    end
  end

  def test_that_apc_is_enabled
      assert system("php -i | grep 'apc.enabled => On'")
  end

  def test_that_timezone_is_europe_brussels
      assert system("php -i | grep 'date.timezone => Europe/Brussels'")
  end

  def test_that_the_service_is_running
    assert system('/etc/init.d/php5-fpm status')
  end

  def test_if_php_version_matches_chosen_version
    case node[:php][:version]
    when "php53"
      assert system('php -v | grep 5.3')
    when "php54"
      assert system('php -v | grep 5.4')
    end
  end

  def test_if_drush_exists
    assert File.exists? "/usr/bin/drush"
  end

  def test_if_drush_is_executable
    assert system('sudo -u vagrant drush')
  end
end
