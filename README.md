Drupal Monitoring
=================

Drupal monitoring using Sensu and drupal monitoring modules:

- https://drupal.org/project/prod_check
- https://drupal.org/project/nagios

Note: Currently only spins up up Sensu dashboard.


Setup
-----

Install Vagrant 1.2+: http://downloads.vagrantup.com/

Run the following commands:

    git clone https://github.com/myplanet-experimental/sensu-drupal-vagrant.git
    cd sensu-drupal-vagrant
    vagrant plugin install bindler --plugin-version=0.1.3
    vagrant bindler setup
    vagrant plugin bundle

Usage
-----

    vagrant up [ drupal | sensu ]

A minimally-configured Drupal site with the Production check & Nagios
modules is now available at:

- `http://localhost:8080`
- username: `admin`
- password: `drupaladmin`

You can also access your Sensu dashboard at:
`http://admin:secret@localhost:8081`

You'll note that Sensu is pre-loaded with a check to monitor the Drupal
instance.

Extended Testing
----------------

You should be able to add your own remote drupal sites by cloning the
demo data bag item within `data_bags/drupal_sites/demo-local.json`.
You'll want to rename the file and internal `id`, as well as point to
your remote website. The `nagios_id` is an identifier that must match
the one you've chosen on your remote site while configuring it with the
Nagios module.  Please read the Nagios module documentation for further
details.

Keep in mind that whenever you update a data bag item, you'll need to
rerun `vagrant provision sensu` before your change will take affect.

*Note that as a precaution, all data bags in the `drupal_sites` directory
(aside from `demo-local.json`) will be ignored. You may edit
`.gitignore` to revert this.*
