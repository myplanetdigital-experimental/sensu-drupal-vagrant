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
    vagrant plugin install bindler
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
