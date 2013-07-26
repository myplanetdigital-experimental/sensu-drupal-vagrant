Drupal Monitoring
=================

Drupal monitoring using Sensu and drupal monitoring modules:

- https://drupal.org/project/prod_check
- https://drupal.org/project/nagios

Note: Currently only spins up up Sensu dashboard.


Setup
-----

    vagrant plugin install bindler
    vagrant bindler setup
    vagrant plugin bundle

Usage
-----

    vagrant up

You can now access your Sensu dashboard at:
`http://admin:secret@localhost:8080` 

A fresh, non-configured Drupal site is also available at:
`http://localhost:8081`
