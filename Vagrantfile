# -*- mode: ruby -*-
# vi: set ft=ruby :

current_dir = File.dirname(__FILE__)

require 'json'
nagios_id = JSON.parse(File.read "#{current_dir}/data_bags/drupal_sites/demo-local.json")['nagios_id']

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
      prod_check_nagios_checks = {
        "settings" => [
          "_prod_check_error_reporting",
          "_prod_check_user_register",
          "_prod_check_site_mail",
        ],
        "server" => [
          "_prod_check_apc",
          "_prod_check_dblog_php",
          "_prod_check_release_notes",
        ],
        "performance" => [
          "_prod_check_page_cache",
          "_prod_check_page_page_compression",
          "_prod_check_boost",
          "_prod_check_block_cache",
          "_prod_check_preprocess_css",
          "_prod_check_preprocess_js",
        ],
        "security" => [
          "_prod_check_node_available",
          "_prod_check_anonymous_rights",
          "_prod_check_admin_username",
        ],
        "modules" => [
          "_prod_check_contact",
          "_prod_check_devel",
          "_prod_check_search_config",
          "_prod_check_update_status",
          "_prod_check_webform",
          "_prod_check_missing_module_files",
        ],
        "seo" => [
          "_prod_check_googleanalytics",
          "_prod_check_metatag",
          "_prod_check_page_title",
          "_prod_check_pathauto",
          "_prod_check_redirect",
          "_prod_check_xmlsitemap",
        ],
      }

      require 'json'
      json_string = JSON.generate(prod_check_nagios_checks)

      sh.inline = <<-EOS
        cd /var/www/drupal
        drush vset nagios_ua #{nagios_id}
        drush vset prod_check_enable_nagios 1
        # Set to 3h rather than 1h dur to cron bug:
        # https://drupal.org/node/1554872
        drush vset nagios_cron_duration 180
        echo '#{json_string}' | drush vset --format=json prod_check_nagios_checks -
      EOS
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
