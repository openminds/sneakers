require 'yaml'

begin
  boxes_configuration = YAML.load_file('config.yml')
rescue Errno::ENOENT
  abort "No config.yml found. Copy config.yml.example to get started."
end

Vagrant::Config.run do |config|
  boxes_configuration.each do |box_config|
    name = box_config[0]
    box = box_config[1]
    config.vm.define name do |node|
      node.vm.host_name = name
      node.vm.forward_port 80, box['http_port']
      Vagrant.configure("2") do |config|
        config.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", "#{box['memory']}"]
        end
      end
      node.vm.box = "debian-6.0.7-amd64-ruby1.9.3.box"
      node.vm.box_url = 'http://mirror.openminds.be/vagrant-boxes/debian-6.0.7-amd64-ruby1.9.3.box'
      node.vm.share_folder "apps", "/home/vagrant/apps/default", box['app_directory']

      node.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "chef/cookbooks"
        chef.roles_path = "chef/roles"

        chef.add_recipe "base"
        chef.json.merge!(:base => {:name => name, :app_settings => box})
        chef.add_recipe "apache"
        chef.add_recipe "nginx"
        chef.add_recipe "mysql"
        chef.add_recipe "phpmyadmin"
        case box['type']
        when /^php5[3|4]$/
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
