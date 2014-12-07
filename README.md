cap-drupal-multisite
====================

Various capistrano tasks to deploy and maintain drupal sites.

It currently only works with Drupal 7.x and Capistrano 3.x.

Features:
* Support for multisite configuration
* Automatically symlink files directory
* Integration of some basic Drush tasks


Installation
------------

Add it as gem to `Gemfile`:

    gem 'capistrano-drupal-multisite', :path => 'vendor/capistrano-drupal-multisite'

Install using 'bundle':

    bundle install


Configuration
-------------

Add the following line to your `Capfile`:

    require 'capistrano-drupal-multisite'
    
Add the following configuration to your `config/deploy.rb`:

    # Path to drupal installation inside the release directory
    set :drupal_path, "public"
    # List of all sites in the sites directory
    set :drupal_sites, %w{default site2}


Usage
-----

The following tasks will be executed after each deployment:

    drupal:symlink          # symlink files directory
    drupal:cache_clear      # clears all caches
    drupal:feature_revert   # reverts all features

Display a list of all available tasks:

    bundle exec cap -T


Bugs & Feedback
---------------

I'm not a Ruby developer so if you have any feedback or found a bug please contact me.


Credits
-------

Most of the code is inspired by other projects like:

* [antistatique/capdrupal](https://github.com/antistatique/capdrupal)
* [mathieue/cap-drupal](https://github.com/mathieue/cap-drupal)
