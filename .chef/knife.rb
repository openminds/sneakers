current_dir = File.dirname(__FILE__)
user        = ENV['OPSCODE_USER'] || ENV['USER']

log_level                :debug
log_location             STDOUT
node_name                `hostname`
client_key               ''
validation_client_name   ''
validation_key           "#{current_dir}/validation.pem"
chef_server_url          ''
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path           "#{current_dir}/../chef/cookbooks" 
cookbook_copyright       'Openminds BVBA'
cookbook_license         'apachev2'
cookbook_email           'tech@openminds.be'
environment_path         "#{current_dir}/../chef/environments"
