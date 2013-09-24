class TestPhp < MiniTest::Chef::TestCase

  def test_that_xdebug_is_enabled
      assert system("php -i | grep 'xdebug support => enabled'")
  end

  def test_that_the_xdebug_config_file_is_added
    assert File.exists?("/etc/php5/mods-available/xdebug.ini")
  end

  def test_that_xdebug_is_installed
    %w[php5-xdebug].each do |pkg|
      assert system("dpkg -l | grep #{pkg}")
    end
  end
end
