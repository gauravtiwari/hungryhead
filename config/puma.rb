#!/usr/bin/env puma

# app do |env|
#   puts env
#
#   body = 'Hello, World!'
#
#   [200, { 'Content-Type' => 'text/plain', 'Content-Length' => body.length.to_s }, [body]]
# end

environment 'development'
daemonize false
port 3000
threads 16,32
preload_app!



# stdout_redirect 'log/puma.log', 'log/puma_err.log'

# quiet



# ssl_bind '127.0.0.1', '9292', { key: path_to_key, cert: path_to_cert }

# on_restart do
#   puts 'On restart...'
# end

# restart_command '/u/app/lolcat/bin/restart_puma'


# === Cluster mode ===

workers 3

# on_worker_boot do
#   puts 'On worker boot...'
# end
