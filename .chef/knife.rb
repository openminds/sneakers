log_level                :auto
log_location             STDOUT
node_name                'solo'
client_key               File.expand_path('../solo.pem', __FILE__)
cache_type               'BasicFile'
cache_options( :path => File.expand_path('../checksums', __FILE__))
cookbook_path [ File.expand_path('../chef/cookbooks', __FILE__) ]
