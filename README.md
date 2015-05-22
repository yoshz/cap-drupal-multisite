cap-drupal-multisite
====================

Various capistrano tasks to deploy and maintain drupal sites.

It currently only works with Drupal 7.x and Capistrano 3.x.

Features:
* Specify and upload settings.php file for each site and stage.
* Automatically symlinking `files` and `private` directory for each site.
* Integration of some basic Drush tasks.
* Synchronize assets and database.


Installation
------------

Add it as gem to `Gemfile`:

    source 'https://rubygems.org'
    group :development do
        gem "capistrano", '~> 3.3.5'
        gem "capistrano-ext"
        gem 'cap-drupal-multisite'
    end

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
    # Group owner of the assets files
    set :drupal_group, "www-data"

You have to specify an own settings.php file for each site and each stage like:

    config/<stage>/settings.<site>.php

You also have to specify an own sites.php for each stage like:

    config/<stage>/sites.php


Usage
-----

Add to following additional optional deploy hooks to your `config/deploy.rb`:

    namespace :deploy do
        after :publishing, "drupal:cache_clear"     # clears all caches
        after :publishing, "drupal:updatedb"        # updates all databases
        after :publishing, "drupal:feature_revert"  # reverts all features
    end

Display a list of all available tasks:

    bundle exec cap -T
    cap drupal:assets:download         # Download assets from <remote>:shared_path to <local>:files/ and <local>:private/ for each site
    cap drupal:assets:upload           # Upload assets from <local>:files/ and <local>:private/ to <remote>:shared_path for each site
    cap drupal:cache_clear             # Clear all caches
    cap drupal:db:download             # Download database dumps from <remote>:release_path to <local>:db/
    cap drupal:db:dump                 # Dump database for each site to <remote>:release_path
    cap drupal:db:restore              # Restore database for each site from dump in <remote>:release_path
    cap drupal:db:upload               # Upload database dumps from <local>:db/ to <remote>:release_path
    cap drupal:feature_revert          # Revert all features
    cap drupal:symlink                 # Symlink shared directories
    cap drupal:updatedb                # Apply any database updates required
    cap drupal:upload_settings         # Upload settings


Bugs & Feedback
---------------

I'm not a Ruby developer so if you have any feedback or found a bug please contact me.


Credits
-------

Most of the code is inspired by other projects like:

* [antistatique/capdrupal](https://github.com/antistatique/capdrupal)
* [mathieue/cap-drupal](https://github.com/mathieue/cap-drupal)
* [sgruhier/capistrano-db-tasks](https://github.com/sgruhier/capistrano-db-tasks)
