class TestWkhtmltopdf < MiniTest::Chef::TestCase

  def test_that_wkhtmltopdf_is_installed
    assert system("dpkg -l | grep wkhtmltopdf")
  end

  def test_that_xvfb_is_installed
    assert system("dpkg -l | grep xvfb")
  end

end
