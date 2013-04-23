name="openminds-vm-0.0.1"

Vagrant::Config.run do |config|
  config.vm.define name do |node|
    node.vm.host_name = name
  end

  config.vm.customize ["modifyvm", :id, "--memory", "1024"]

  config.vm.box = "debian-6.0.7-amd64-ruby1.9.3.box"
  config.vm.box_url = 'http://mirror.openminds.be/vagrant-boxes/debian-6.0.7-amd64-ruby1.9.3.box'
  # config.vm.boot_mode = :gui
  # config.vm.network "33.33.33.10"
  config.vm.forward_port 80, 8080
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.roles_path = "chef/roles"

    chef.add_recipe "base"
    chef.add_recipe "apache"
    chef.add_recipe "chef_handler"
    chef.add_recipe "minitest-handler"
    chef.json.merge!(:base => {:wot => false })
  end
end
