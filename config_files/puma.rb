#!/usr/bin/env puma

directory '/home/ubuntu/apps/wave-ekyc-backend/current'
rackup "/home/ubuntu/apps/wave-ekyc-backend/current/config.ru"
environment 'staging'

tag ''

pidfile "/home/ubuntu/apps/wave-ekyc-backend/shared/tmp/pids/puma_v3.pid"
state_path "/home/ubuntu/apps/wave-ekyc-backend/shared/tmp/pids/puma_v3.state"
stdout_redirect '/home/ubuntu/apps/wave-ekyc-backend/current/log/puma_v3.stdout.log', '/home/ubuntu/apps/wave-ekyc-backend/current/log/puma_v3.stderr.log', true

threads 4,16

bind 'unix:///home/ubuntu/apps/wave-ekyc-backend/shared/tmp/sockets/wave-ekyc-backend_puma.sock'

port 5000

workers 4

restart_command 'bundle exec puma'

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
