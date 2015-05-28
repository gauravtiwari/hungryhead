custom_web: bundle exec unicorn_rails -c config/unicorn.rb -E $RAILS_ENV -D

worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=$REDIS_URL_INT bundle exec sidekiq -C config/sidekiq.yml -i {{UNIQUE_INT}}

cron: bundle exec crono RAILS_ENV=$RAILS_ENV