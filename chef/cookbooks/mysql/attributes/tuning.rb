default[:mysql][:innodb_buffer_pool_size] = "#{node[:memory][:total].to_i / 3 / 1024}M"
