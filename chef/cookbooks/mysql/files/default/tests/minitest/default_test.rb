class TestMySQL < MiniTest::Chef::TestCase
  def test_that_the_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/mariadb.list")
  end

  def test_that_the_config_file_is_added
    assert File.exists?("/etc/mysql/my.cnf")
    assert File.exists?("/root/.my.cnf")
    assert File.exists?("/home/vagrant/.my.cnf")
  end

  def test_that_the_packages_are_installed
    %w[libmariadbclient-dev mariadb-server-5.5].each do |pkg|
      assert system("dpkg -l | grep #{pkg}")
    end
  end

  def test_that_the_service_is_running
    assert system('/etc/init.d/mysql status')
  end

  def test_that_the_service_is_enabled
    assert File.exists?(Dir.glob("/etc/rc5.d/S*mysql").first)
  end

  def test_mysql_connection
    assert system("mysql mysql -e 'SELECT Host,User,Password FROM user LIMIT 1;'")
  end

  def test_innodb_buffer_pool_size
    assert system("cat /etc/mysql/conf.d/innodb_tuning.cnf | grep innodb_buffer_pool_size")
  end
end
