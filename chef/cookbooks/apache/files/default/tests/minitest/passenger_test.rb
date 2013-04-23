class TestApache2Passenger < MiniTest::Chef::TestCase
  def test_that_the_config_file_is_added
    assert File.exists?("/etc/apache2/mods-available/passenger.conf")
  end

  def test_that_the_packages_are_installed
    %w[libapr1-dev libaprutil1-dev libpq5 libcurl4-openssl-dev libxslt1-dev libxml2-dev apache2-prefork-dev dpatch libaprutil1-dev libapr1-dev libpcre3-dev sharutils libpq-dev].each do |pkg|
      assert system("dpkg -l | grep #{pkg}")
    end
  end

  def test_that_passenger_module_is_enabled
      assert system("apache2ctl -M | grep -i passenger")
  end

  def test_if_bundler_is_installed
      assert system("gem list | grep bundler")
  end
end
