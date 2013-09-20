default[:php][:version] = "php53"
default[:php][:timezone] = "Europe/Brussels"
default[:php][:html_errors] = "Off"
default[:php][:max_execution_time] = 60
default[:php][:max_input_time] = 60
default[:php][:memory_limit] = "192M"
default[:php][:error_reporting] = "E_ALL & ~E_DEPRECATED"
default[:php][:display_errors] = "Off"
default[:php][:display_startup_errors] = "Off"
default[:php][:upload_max_filesize] = "32M"

default[:php][:packages] = %w[ php5-cli php5-common php5-fpm php5-curl php5-dev php5-gd php5-imagick php5-imap php5-mcrypt php5-mysql php5-xmlrpc php-pear php5-intl php5-apc ]
