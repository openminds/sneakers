![Openminds logo](http://november.openminds.be/~steven/sneaker.png)

# Openminds Sneakers

## Description

Sneakers is a simple, fast way to mimick Openminds Shared and Cloud hosting environments. We do this using vagrant/virtualbox provisioned by Chef.
You can develop your websites and test it straight on the VM (Virtual Machine) without the need for deploying or doing complex tasks.
If your website works in our Sneakers, it should work on our production servers.

## Dependencies

Only three, and in that order:

 * [Git](http://git-scm.com)
 * [Virtualbox](https://www.virtualbox.org)
 * [Vagrant](http://www.vagrantup.com)

## Currently supported

These are the servers we can currently mimick:

 * Cloud hosting PHP 5.3
 * Cloud hosting PHP 5.4
 * Cloud hosting Ruby 1.9.3
 * Shared hosting PHP 5.3 (shared-017)
 * Shared hosting PHP 5.4 (shared-018)
 * Shared hosting Ruby 1.9.3 (pro-007, pro-008)

soon(-ish): shared varnish support

## Getting started

Clone this repository:

    git clone git://github.com/openminds/sneakers.git

Make sure all submodules are up-to-date:

    git submodule update --init

Copy the config file:

    cp config.yml.example config.yml

Edit the config file to represent your apps. You can add as many as you want (as long as your physical memory permits it), this example has two apps:

    myapp:
      app_directory: "/Users/steven/Developer/myapp"
      type: "php54"
      http_port: 9000
      memory: 1024

    myotherapp:
      app_directory: "/Users/steven/Developer/myotherapp"
      type: "ruby193"
      http_port: 9001
      memory: 1024

 * _myapp_: This will be the name of your VM (unique identifier), change it to whatever makes sense to you.
 * _app_directory_: The directory your app resides on the host machine (i.e. your laptop)
 * _type_: Type of app you will use, this can be php53, php54, ruby193, ..
 * _http\_port_: The VM will forward port 80 to another port on your machine. pick a port that's unused on your local machine.
 * _memory_: How much memory your VM may use. Be carefull, the more memory your VM has, the less your host machine has.

** Optional: **

 * _mysql_port_: enables port forwarding to the mysql port, to the port specified
 * _documentroot_suffix_: sets documentroot suffix, for when your application is in a subdirectory of the shared folder.
 * _php_xdebug_: enables [xdebug](http://xdebug.org/) support for php

Caveats:
 * each app will run in its own VM, so make sure that if you add multiple apps that they all have a different http_port set up.
 * this is a yml file, indentation is important.

To start a VM:

    vagrant up myapp

(make sure to specify the app name, or you will start _all_ VM's)

To stop a VM:

    vagrant halt myapp

To destroy a VM:

    vagrant destroy myapp

To destroy all VM's:

    vagrant destroy

If you run `vagrant` by itself, help will be displayed showing all available subcommands. In addition to this, you can run any Vagrant command with the `-h` flag to output help about that specific command.

Develop your app in the directory you've given with the `app_directory` parameter. When you surf to `http://localhost:9000` (or not 9000 but another port you've set with http_port) you should see your website as it would show on an Openminds production server.

### Databases

You should have a database with a database user named after your app. In this example that would be `myapp` or `myotherapp`. Password will always be `vagrant`. The mysql root user also has password `vagrant`. phpMyAdmin is available under `http://localhost:9000/phpmyadmin` (change port 9000 if applicable).

To list the credentials of the default example:

    * database: myapp
    * database user: myapp
    * database password: vagrant

    * database root user: root
    * database root password: vagrant

    * phpMyADmin: http://localhost:9000/phpmyadmin

If you want to connect from the host machine, you need to set `mysql_port` in `config.yml` and connect to the port on `127.0.0.1`. For example (given `mysql_port` is set to `3308` in `config.yml` for `myapp`):

    mysql -P 3308 -h 127.0.0.1 -u myapp -p myapp

## Issues and Feedback

Please submit issues through Github 'issues', or mail us at support@openminds.be. Feel free to give feedback.

## Todo's

 * Mimick Shared Varnish
 * Capistrano deploy.rb config generator

## Known Issues

### If your run is stuck on `waiting for vm to boot`

You're probably running on a 32bit machine.

Virtualbox can not run 64bit VM's on a 32bit host system. Since our debian images are 64bit, this makes sneakers incompatible with 32bit host systems.
We run 64bit kernels in production and thus are not planning on supporting 32bit images in sneakers.

One work-around (though you're on your own if you get in trouble):

Change `node.vm.box` and `node.vm.box_url` in Vagrantfile to:

    `node.vm.box = "debian-6.0.7-amd64-ruby1.9.3.box"`
    `node.vm.box_url = 'http://mirror.openminds.be/vagrant-boxes/openminds-debian-squeeze-i386.box'`

Your vagrant run will fail. Log in with `vagrant ssh` and run the following:

    `sudo -i`
    `/opt/chef/embedded/bin/gem install chef`

Try again with `vagrant provision`
