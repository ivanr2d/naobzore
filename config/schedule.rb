# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :rake, "cd /home/naobzore/current && RAILS_ENV=:environment bundle exec rake :task --silent :output"

every 1.day, :at => '07:00', :roles => [:app] do
  log_file = 'log/subscribes.log'
  rake 'naobzore:subscribes:send', :output => { :standard => log_file, :error => log_file }
end

every 1.day, :at => '03:00', :roles => [:app] do
  log_file = 'log/packages.log'
  rake 'naobzore:packages:prolongate', :output => { :standard => log_file, :error => log_file }
end

every 1.day, :at => '04:00', :roles => [:app] do
  log_file = 'log/packages.log'
  rake 'naobzore:packages:delete', :output => { :standard => log_file, :error => log_file }
end

every 1.week, :roles => [:app] do
  log_file = 'log/banners.log'
  rake 'naobzore:banners:acts_factures', :output => { :standard => log_file, :error => log_file }
end

every 1.week, :roles => [:app] do
  log_file = 'log/notifications.log'
  rake 'naobzore:notifications:send', :output => { :standard => log_file, :error => log_file }
end

every 1.week, :at => '05:00', :roles => [:app] do
  log_file = 'log/read_marks.log'
  rake 'naobzore:read_marks:compact', :output => { :standard => log_file, :error => log_file }
end
