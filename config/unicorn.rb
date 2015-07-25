# Set your full path to application.
app_dir = File.expand_path('../', __dir__)

if ENV['RAILS_ENV'] == 'development'
  worker_processes 1
  logger           Logger.new(STDOUT, STDERR)
else
  worker_processes 3
end

preload_app       true
timeout           30

# Fill path to your app
working_directory app_dir

# Set up socket location
listen            "#{app_dir}/tmp/sockets/unicorn.sock", :backlog => 64
listen            3000, :tcp_nopush => true

# Loging
stderr_path       "#{app_dir}/log/unicorn.stderr.log"
stdout_path       "#{app_dir}/log/unicorn.stdout.log"

# Set master PID location
pid               "#{app_dir}/tmp/pids/unicorn.pid"

GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly == true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end