# -*- mode: ruby -*-
# vi: set ft=ruby :

current_dir = File.dirname(__FILE__)

require 'json'
nagios_id = JSON.parse(File.read "#{current_dir}/data_bags/drupal_sites/demo.json")['nagios_id']

Vagrant.configure("2") do |config|
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.omnibus.chef_version = "11.6.0"
  config.cache.auto_detect = true

  # Set defaults until issue resolved:
  # https://github.com/mitchellh/vagrant/issues/1113
  chef_default = proc do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.add_recipe "apt"
    chef.add_recipe "vim"
    chef.add_recipe "curl"
  end

  config.vm.define :drupal do |drupal|
    drupal.vm.network :private_network, ip: "192.168.33.2"
    drupal.vm.hostname = "drupal.local"
    drupal.vm.network :forwarded_port, guest: 80, host: 8080
    drupal.vm.provision :chef_solo do |chef|
      chef_default.call(chef)
      chef.add_recipe "drupal"
      chef.json = {
        :drupal => {
          :drush => {
            :version => "7.x-5.9",
          },
          :modules => [
            "prod_check",
            "nagios",
          ],
          :version => "7.22",
        },
        :mysql => {
          :server_debian_password => "root",
          :server_root_password =>   "root",
          :server_repl_password =>   "root",
        },
      }
    end

    drupal.vm.provision :shell do |sh|
      sh.inline = "cd /var/www/drupal && drush vset nagios_ua #{nagios_id}"
    end
  end

  config.vm.define :sensu do |sensu|
    sensu.vm.network :private_network, ip: "192.168.33.1"
    sensu.vm.hostname = "sensu.local"
    sensu.vm.network :forwarded_port, guest: 8080, host: 8081
    sensu.vm.provision :chef_solo do |chef|
      chef_default.call(chef)
      chef.add_recipe "monitor::master"
      chef.add_recipe "drupal-monitor"

      chef.json = {
        :sensu => {
          :use_ssl => false,
        },
      }
    end
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "3000"]
  end

end
