# Load default values
namespace :load do
  task :defaults do
    set :drush, "drush"
    set :drupal_path, "public"
    set :drupal_sites, %w{default}
  end
end

# Set deploy hooks
namespace :deploy do
  after :updating, "drupal:symlink"
  after :updating, "drupal:upload_settings"
end

# Specific Drupal tasks
namespace :drupal do

  desc "Symlink shared directories"
  task :symlink do
    on roles(:all) do
      fetch(:drupal_sites).each do |site|
        execute "mkdir", "-p #{shared_path}/#{site}/files #{shared_path}/#{site}/private"
        execute "ln", "-nfs #{shared_path}/#{site}/files #{release_path}/#{fetch(:drupal_path)}/sites/#{site}/files"
        execute "ln", "-nfs #{shared_path}/#{site}/private #{release_path}/#{fetch(:drupal_path)}/sites/#{site}/private"
        #execute :drush, "-l #{site} -r #{release_path}/#{fetch(:drupal_path)} vset --yes file_directory_path sites/#{site}/files"
      end
    end
  end

  desc "Upload settings"
  task :upload_settings do
    on roles(:all) do
      fetch(:drupal_sites).each do |site|
        upload! "config/#{fetch(:stage)}/settings.#{site}.php", "#{release_path}/#{fetch(:drupal_path)}/sites/#{site}/settings.php"
      end
      upload! "config/#{fetch(:stage)}/sites.php", "#{release_path}/#{fetch(:drupal_path)}/sites/sites.php"
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

  namespace :db do

    desc 'Dump database for each site to <remote>:release_path'
    task :dump do 
      on roles(:all) do
        within "#{release_path}/#{fetch(:drupal_path)}" do
          fetch(:drupal_sites).each do |site|
            execute :drush, "-l #{site} sql-dump | gzip > #{release_path}/#{site}.sql.gz"
          end
        end
      end
    end

    desc 'Restore database for each site from dump in <remote>:release_path'
    task :restore do 
      on roles(:all) do
        within "#{release_path}/#{fetch(:drupal_path)}" do
          fetch(:drupal_sites).each do |site|
            execute "zcat #{release_path}/#{site}.sql.gz", :drush, "-l #{site} -q sql-connect"
          end
        end
      end
    end

    desc 'Download database dumps from <remote>:release_path to <local>:db/'
    task :download do 
      on roles(:all) do
        within "#{release_path}/#{fetch(:drupal_path)}" do
          fetch(:drupal_sites).each do |site|
            download! "#{release_path}/#{site}.sql.gz", "db/"
          end
        end
      end
    end

    desc 'Upload database dumps from <local>:db/ to <remote>:release_path'
    task :upload do 
      on roles(:all) do
        within "#{release_path}/#{fetch(:drupal_path)}" do
          fetch(:drupal_sites).each do |site|
            upload! "db/#{site}.sql.gz", "#{release_path}/#{site}.sql.gz"
          end
        end
      end
    end
  end

  namespace :assets do

    desc 'Download assets from <remote>:shared_path to <local>:files/ and <local>:private/ for each site'
    task :download do 
      on roles(:all) do |server|
        fetch(:drupal_sites).each do |site|
          puts "Downloading files of #{site} from #{server}"
          system("rsync -a --del -L -K --rsh='ssh -p #{server.port}' #{server.user}@#{server.hostname}:#{shared_path}/#{site}/files/ files/#{site}")
          system("rsync -a --del -L -K --rsh='ssh -p #{server.port}' #{server.user}@#{server.hostname}:#{shared_path}/#{site}/private/ private/#{site}")
        end
      end
    end

    desc 'Upload assets from <local>:files/ and <local>:private/ to <remote>:shared_path for each site'
    task :upload do 
      on roles(:all) do |server|
        fetch(:drupal_sites).each do |site|
          puts "Uploading files of #{site} to #{server}"
          system("rsync -a --del -L -K --rsh='ssh -p #{server.port}' files/#{site}/ #{server.user}@#{server.hostname}:#{shared_path}/#{site}/files")
          system("rsync -a --del -L -K --rsh='ssh -p #{server.port}' private/#{site}/ #{server.user}@#{server.hostname}:#{shared_path}/#{site}/private")
        end
      end
    end
  end
end
