class TestPhpMyAdmin < MiniTest::Chef::TestCase

  def test_that_the_phpmyadmin_config_file_is_added
    assert File.exists?("/home/phpmyadmin/default_www/config.inc.php")
  end

  def test_that_phpmyadmin_is_added_to_vhost
    assert system("cat /etc/apache2/sites-enabled/000-default | grep -i phpmyadmin")
  end

  def test_phpmyadmin_page
    assert Net::HTTP.get(URI.parse("http://127.0.0.1:8080/phpmyadmin"))
  end
end
