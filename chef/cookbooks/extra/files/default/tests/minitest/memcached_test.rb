class TestMemcached < MiniTest::Chef::TestCase
  def test_that_the_memcached_packages_are_installed
    %w[ memcached php5-memcached ].each do |pkg|
      assert system("dpkg -l | grep #{pkg}")
    end
  end

  def test_that_the_memcached_config_file_is_added
    assert File.exists?("/etc/memcached.conf")
  end

  def test_that_the_memcached_service_is_running
    assert system('/etc/init.d/memcached status')
  end
end
