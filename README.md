![Openminds logo](http://november.openminds.be/~steven/om-logo.png)

# Boxers

## Description

Boxers is a simple, fast way to mimick Openminds Shared and Cloud hosting environments. We do this using vagrant/virtualbox provisioned by Chef.
You can develop your websites and test it straight on the VM (Virtual Machine) without the need for deploying or doing complex tasks.
If your website works in our boxers, it should work on our production servers.

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

    git clone https://github.com/openminds/boxers

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

Develop your app in the directory you've given with the `app_directory` parameter. When you surf to `http://localhost:9000` (or nog 9000 but another port you've set with http_port) you should see your website as it would show on an Openminds production server.
