require 'yaml'

env_config = YAML.load_file('config.yml')

name = env_config['name']

Vagrant::Config.run do |config|
  config.vm.define name do |node|
    node.vm.host_name = name
  end

  config.vm.customize ["modifyvm", :id, "--memory", "1024"]

  config.vm.box = "debian-6.0.7-amd64-ruby1.9.3.box"
  config.vm.box_url = 'http://mirror.openminds.be/vagrant-boxes/debian-6.0.7-amd64-ruby1.9.3.box'
  config.vm.forward_port 80, env_config['http_port']
  config.vm.share_folder "apps", "/home/vagrant/apps/default", env_config['app_directory']

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.roles_path = "chef/roles"

    chef.add_recipe "base"
    chef.add_recipe "apache"
    chef.add_recipe "nginx"
    case env_config['type']
    when "php53" || "php54"
      chef.add_recipe "apache::php"
      chef.json.merge!(:php => {:version => env_config['type'] })
    when "ruby193"
      chef.add_recipe "apache::passenger"
    else
      raise "Unknown type of server. Needs to be php53, ruby193, ... Please RTFM."
    end
    ## Enable for Chef development:
    # chef.add_recipe "chef_handler"
    # chef.add_recipe "minitest-handler"
  end
end
