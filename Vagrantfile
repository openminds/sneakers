require 'yaml'

boxes_configuration = YAML.load_file('config.yml')

Vagrant::Config.run do |config|
  boxes_configuration.each do |box_config|
    box = box_config[1]
    config.vm.define box['name'] do |node|
      node.vm.host_name = box['name']
      node.vm.forward_port 80, box['http_port']
      node.vm.customize ["modifyvm", :id, "--memory", "#{box['memory']}"]
      node.vm.box = "debian-6.0.7-amd64-ruby1.9.3.box"
      node.vm.box_url = 'http://mirror.openminds.be/vagrant-boxes/debian-6.0.7-amd64-ruby1.9.3.box'
      node.vm.share_folder "apps", "/home/vagrant/apps/default", box['app_directory']

      node.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "chef/cookbooks"
        chef.roles_path = "chef/roles"

        chef.add_recipe "base"
        chef.add_recipe "apache"
        chef.add_recipe "nginx"
        case box['type']
        when "php53" || "php54"
          chef.add_recipe "apache::php"
          chef.json.merge!(:php => {:version => box['type'] })
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
  end
end
