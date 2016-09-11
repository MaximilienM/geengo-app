require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'

  # See
  # https://github.com/defunkt/resque/issues/333
  # http://stackoverflow.com/questions/6137570/resque-enqueue-failing-on-second-run
  Resque.before_fork do |job|
    ActiveRecord::Base.establish_connection
  end

end