web: bundle exec puma -e $RACK_ENV -b unix:///tmp/web_server.sock --pidfile /tmp/web_server.pid -d --config config/puma.rb
#web: bundle exec unicorn_rails -p 3000 -c ./config/unicorn.rb
#redis: redis-server
#database: postgres -D /usr/local/var/postgres
# web: bundle exec rails s -u -p $PORT webrick
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=redis://$REDIS_ADDRESS bundle exec sidekiq -C config/sidekiq.yml -i {{UNIQUE_INT}}

cron: bundle exec crono RAILS_ENV=$RAILS_ENV