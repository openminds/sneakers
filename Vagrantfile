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
    throw "http_port can not be #{box['http_port']}. Please change it." if [111, 45587, 22, 25, 3306, 22, 42].include? box['http_port']

    config.vm.define name do |node|
      node.vm.host_name = name
      node.vm.forward_port box['http_port'], box['http_port']
      node.vm.forward_port 3306, box['mysql_port'] if box['mysql_port']
      node.vm.network :hostonly, "#{box['ip'] || '10.11.12.13'}" if box['nfs'] || box['ip']
      Vagrant.configure("2") do |config|
        config.vm.provider :virtualbox do |vb|
          vb.customize ["modifyvm", :id, "--memory", "#{box['memory']}"]
        end
      end
      node.vm.box = "sneakers-6.0.7-#{box['type']}-20130911"
      node.vm.box_url = "http://mirror.openminds.be/vagrant-boxes/sneakers-6.0.7-#{box['type']}-20130911.box"
      node.vm.share_folder "apps", "/home/vagrant/apps/default", box['app_directory'], :nfs => box['nfs']

      node.vm.provision :chef_solo do |chef|
        chef.log_level = :auto

        chef.cookbooks_path = "chef/cookbooks"
        chef.roles_path = "chef/roles"

        chef.add_recipe "base"
        chef.json.merge!(
          :base => {
            :name => name,
            :app_settings => box
          },
          :minitest => {
            :verbose => false
          }
        )
        chef.add_recipe "apache"
        chef.add_recipe "nginx"
        chef.add_recipe "mysql"
        chef.add_recipe "phpmyadmin"
        chef.add_recipe "extra::wkhtmltopdf" if box['wkhtmltopdf']
        chef.add_recipe "extra::memcached" if box['memcached']
        case box['type']
        when /^php5[3|4]$/
          chef.add_recipe "apache::php"
          chef.json.merge!(:php => {:version => box['type'] })
          chef.add_recipe "apache::php_xdebug" if box['php_xdebug']
        when "ruby193"
          chef.add_recipe "apache::passenger"
        else
          raise "Unknown type of server. Needs to be php53, ruby193, ... Please consult the README."
        end
        ## Enable for Chef development:
        # chef.add_recipe "chef_handler"
        # chef.add_recipe "minitest-handler"
      end
    end
  end
end
