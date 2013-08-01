demo_site = data_bag_item('drupal_sites', 'demo')

sensu_client "drupal" do
  address demo_site['address']
  subscriptions ["all", "drupal"]
  additional({
    :nagios_id => demo_site['nagios_id'],
  })
end

# check_drupal requires Nagios utils.sh script
package "nagios-plugins"

remote_file "/usr/lib/nagios/plugins/check_drupal" do
  source "http://drupalcode.org/project/nagios.git/blob_plain/7.x-1.2:/nagios-plugin/check_drupal"
  owner "root"
  group "root"
  mode "0755"
end

sensu_check "check_drupal" do
  command "PATH=$PATH:/usr/lib64/nagios/plugins:/usr/lib/nagios/plugins check_drupal -H :::address::: -U :::nagios_id:::"
  handlers ["default"]
  subscribers ["drupal"]
  interval 60
  additional({
    :notification => "Issue with Drupal site.",
    :occurrences => 5,
  })
end
