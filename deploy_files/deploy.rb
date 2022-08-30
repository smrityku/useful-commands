#
# Don't change these unless you know what you're doing
#Server, User and roles defined based on environment's files like (production.rb, staging.rb and dev.rb)
#

# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

set :repo_url,        'git@github.com:misfit-tech/wave-ekyc-backend.git'
set :application,     'wave-ekyc-backend'
set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :rvm_type, :ubuntu
set :rvm_ruby_version, '2.7.1'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :assets_roles, []

## Linked Files & Directories (Default None):
set :linked_files, %w[config/application.yml config/database.yml config/secrets.yml pumactl.wave-ekyc-backend]

set(
    :linked_dirs,
    %w[log tmp/pids tmp/states tmp/sockets tmp/cache vendor/bundle public/uploads storage node_modules]
)

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "rm -rf #{shared_path}/tmp/sockets/#{fetch(:application)}_#{fetch(:stage)}_puma.sock"
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Stop PUMA manually and then start'
  task :manual_start do
    on roles(:app) do
      # Make sure the bash script is executable
      execute ". #{current_path}/pumactl.wave-ekyc-backend", pty: false
    end
  end

  Rake::Task[:restart].clear_actions
  desc "Overwritten puma:restart task"
  task :restart do
    invoke 'puma:manual_start'
  end
end

namespace :deploy do
  desc 'Yarn install'
  task :yarn_install do
    on roles(:app) do
      execute "yarn install --path /home/ubuntu/apps/wave-ekyc-backend/shared/node_modules"
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:restart'
      invoke 'deploy'
    end
  end

  before :deploy,       'puma:make_dirs'
  # before :starting,     :check_revision
  # after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end
