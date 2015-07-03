web: bundle exec passenger start
worker: env RAILS_ENV=$RAILS_ENV REDIS_URL=$REDIS_URL_INT bundle exec sidekiq -C config/sidekiq.yml -i {{UNIQUE_INT}}
cron: bundle exec crono RAILS_ENV=$RAILS_ENV