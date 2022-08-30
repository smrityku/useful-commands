#
# Don't change these unless you know what you're doing
#

# server "db.example.com", user: "deploy", roles: %w{db}
server '18.142.145.141', user: 'ubuntu', roles: %w{app db web}

#Set user of your operating system
set :user,            'ubuntu'
#Set puma threads
set :puma_threads,    [4, 16]
#Set puma workers
set :puma_workers,    4
# Set Stage and environment from which you want to deploy
set :stage,           :staging
# Set rails environment from which you want to deploy
set :rails_env,       :staging
# Set deploy to directory path
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
#Set puma binding path
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"

# Set ssh key value/pem file here if you want to disable password authentication while deploying
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/xyz-innovation.pem) }

# Set branch from which you want to deploy
set :branch,        :'development'
# Set how much releases versions you want to keep.
set :keep_releases, 5

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/development`
        puts "WARNING: HEAD is not the same as origin/development"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end
  # before :starting,     :check_revision
end