
# Load default values the capistrano 3.x way.
# See https://github.com/capistrano/capistrano/pull/605
namespace :load do
  task :defaults do
    set :drush, "drush"
    set :drupal_path, "public"
    set :drupal_sites, %w{default}
  end
end

namespace :deploy do
  after :updating, "drupal:symlink"
  after :publishing, "drupal:updatedb"
  after :publishing, "drupal:cache_clear"
  after :publishing, "drupal:feature_revert"
end

# Specific Drupal tasks
namespace :drupal do

  desc "Symlink shared directories"
  task :symlink do
    on roles(:all) do
      fetch(:drupal_sites).each do |site|
        execute "mkdir", "-p #{shared_path}/#{site}/files"
        execute "ln", "-nfs #{shared_path}/#{site}/files #{release_path}/#{fetch(:drupal_path)}/sites/#{site}/files"
        #execute :drush, "-l #{site} -r #{release_path}/#{fetch(:drupal_path)} vset --yes file_directory_path sites/#{site}/files"
      end
    end
  end

  desc "Apply any database updates required"
  task :updatedb do
    on roles(:all) do
      within "#{release_path}/#{fetch(:drupal_path)}" do
        fetch(:drupal_sites).each do |site|
          execute :drush, "-l #{site} -y updatedb"
        end
      end
    end
  end

  desc "Revert all features"
  task :feature_revert do
    on roles(:all) do
      within "#{release_path}/#{fetch(:drupal_path)}" do
        fetch(:drupal_sites).each do |site|
          execute :drush, "-l #{site} -y features-revert-all"
        end
      end
    end
  end

  desc 'Clear all caches'
  task :cache_clear do
    on roles(:all) do
      within "#{release_path}/#{fetch(:drupal_path)}" do
        fetch(:drupal_sites).each do |site|
          execute :drush, "-l #{site} -y cache-clear all"
        end
      end
    end
  end

end
