require 'yaml'

begin
  boxes_configuration = YAML.load_file('config.yml')
rescue Errno::ENOENT
  abort "No config.yml found. Copy config.yml.example to get started."
end

boxes_configuration.each do |box_config|
  name = box_config[0]
  throw "The name of you app can not be longer than 16 characters (due to db name restrictions)." if name.length > 16
  box = box_config[1]
  throw "http_port can not be #{box['http_port']}. Please change it." if [111, 45587, 22, 25, 3306, 22, 42].include? box['http_port']

  Vagrant.configure("2") do |config|
    config.vm.define name do |node|
      node.vm.host_name = name
      node.vm.network :forwarded_port, guest: box['http_port'], host: box['http_port']
      node.vm.network :forwarded_port, guest: 3306, host: box['mysql_port'] if box['mysql_port']
      node.vm.network :private_network, ip: "#{box['ip'] || '10.11.12.13'}"

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", box['memory']]
      end

      if box['type'] == "php53"
        node.vm.box = "sneakers-6.0.7-#{box['type']}-20130911"
        node.vm.box_url = "http://mirror.openminds.be/vagrant-boxes/sneakers-6.0.7-#{box['type']}-20130911.box"
      else
        node.vm.box = "sneakers-7.3.0-#{box['type']}-20140129"
        node.vm.box_url = "http://mirror.openminds.be/vagrant-boxes/sneakers-7.3.0-#{box['type']}-20140129.box"
      end
      node.vm.synced_folder box['app_directory'], "/home/vagrant/apps/default", nfs: box['nfs']

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
          if box['php_memory_limit']
            chef.json.merge!(:php => {:memory_limit => box['php_memory_limit'], :version => box['type'] })
          else
            chef.json.merge!(:php => {:version => box['type'] })
          end
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
