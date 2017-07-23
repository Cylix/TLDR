# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "tldr"
set :repo_url, "git@github.com:Cylix/TLDR.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/tldr.simon-ninon.fr"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# capistrano/passenger => restart by `touch tmp/restart.txt`
set :passenger_restart_with_touch, true

after "deploy", "deploy:cron_tab_update"

namespace :deploy do
  desc 'cron tab update'
  task :cron_tab_update do
    on roles(:web) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :bundle, 'exec whenever -w'
        end
      end
    end
  end
end
