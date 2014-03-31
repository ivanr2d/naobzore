set :application, "naobzore"
set :repository,  "."

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "159.253.21.86"                          # Your HTTP server, Apache/etc
role :app, "159.253.21.86"                          # This may be the same as your `Web` server
role :db,  "159.253.21.86", :primary => true # This is where Rails migrations will run
role :db,  "159.253.21.86"

set :user, 'naobzore'
set :use_sudo, false
set :deploy_to, "/home/#{application}"

set :scm, "git"
set :branch, ENV['BRANCH'] || "master"
set :scm_verbose, true
set :deploy_via, :remote_cache

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# TODO fix and enable
# set :whenever_command, "bundle exec whenever"
# require 'whenever/capistrano'
# set :whenever_roles, [:app]
