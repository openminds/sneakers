class TestWkhtmltopdf < MiniTest::Chef::TestCase
  def test_that_wkhtmltopdf_is_installed
    assert File.exists?('/usr/local/bin/wkhtmltopdf')
  end
end
