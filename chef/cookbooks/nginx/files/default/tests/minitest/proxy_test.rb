class TestNginxProxy < MiniTest::Chef::TestCase
  def test_that_the_vhost_config_is_added
    assert File.exists?("/etc/nginx/proxy_vhost.conf")
  end

  def test_that_the_proxy_config_is_added
    assert File.exists?("/etc/nginx/extra.d/proxy.conf")
  end

  def test_that_the_default_config_is_added
    assert File.exists?("/etc/nginx/conf.d/default.conf")
  end
end
