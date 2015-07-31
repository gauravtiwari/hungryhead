web: bundle exec passenger start
worker: env RAILS_ENV=$RAILS_ENV bundle exec sidekiq -C config/sidekiq.yml -i {{UNIQUE_INT}}
#cron: bundle exec crono RAILS_ENV=$RAILS_ENV