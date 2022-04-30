require 'server/starter/puma_listener'
listener = ::Server::Starter::PumaListener

APP_ROOT = File.expand_path('../..', __FILE__)
status_file = File.join(APP_ROOT, 'log/start_server.stat')

pidfile File.join(APP_ROOT, 'log/puma.pid')
state_path File.join(APP_ROOT, 'log/puma.state')

threads 0, 16
workers 2

preload_app!

if ENV['SERVER_STARTER_PORT']
  puma_inherits = listener.listen
  puma_inherits.each do |puma_inherit|
    bind puma_inherit[:url]
  end
else
  puts '[WARN] Fallback to 0.0.0.0:10080 since not running under Server::Starter'
  bind 'tcp://0.0.0.0:10080'
end
