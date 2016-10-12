# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'prizy-tools'
set :repo_url, 'git@github.com:btoacompany/prizy-tools.git'
set :branch, :master
set :deploy_to, '/home/deploy/prizy-tools'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5

namespace :deploy do
 desc 'Restart application'
 task :restart do
 invoke 'unicorn:restart'
 end
end

after 'deploy:publishing', 'deploy:restart'
