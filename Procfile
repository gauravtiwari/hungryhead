web: bundle exec puma --config config/puma.rb
#web: bundle exec unicorn_rails -p 3000 -c ./config/unicorn.rb
redis: redis-server
#database: postgres -D /usr/local/var/postgres
# web: bundle exec rails s -u -p $PORT webrick
worker: bundle exec sidekiq -c ${SIDEKIQ_CONCURRENCY:=3}

cron: bundle exec crono RAILS_ENV=development