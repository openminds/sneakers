class TestNginx < MiniTest::Chef::TestCase
  def test_that_the_repository_is_added
    assert File.exists?("/etc/apt/sources.list.d/nginx.list")
  end

  def test_that_the_service_is_running
    assert system('/etc/init.d/nginx status')
  end

  def test_that_the_mimetypes_file_is_added
    assert File.exists?("/etc/nginx/mime.types")
  end

  def test_that_the_service_is_enabled
    assert File.exists?(Dir.glob("/etc/rc5.d/S*nginx").first)
  end

  def test_connection_page
    assert Net::HTTP.get(URI("http://127.0.0.1:#{node[:base][:app_settings].http_port.to_s}"))
  end
end
