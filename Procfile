worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=redis://$REDIS_ADDRESS bundle exec sidekiq -C config/sidekiq.yml -i {{UNIQUE_INT}}

cron: bundle exec crono RAILS_ENV=$RAILS_ENV