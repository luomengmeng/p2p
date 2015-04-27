require 'resque'
require 'resque/tasks'
require 'resque/scheduler/tasks'
task "resque:preload" => :environment

Resque.logger = Logger.new STDOUT
Resque.logger.level = Logger::DEBUG

task "resque:setup" => :environment do
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end