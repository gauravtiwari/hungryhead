# Hungryhead (Now Demo only)

Hungryhead is a collaborative network for students to share, validate and develop startup ideas with peers and mentors, supported by gamification.

The platform was built on Rails - standard monolith. Currently, this code is used in production for demo purposes only. The source code is now more than a year old and contains many things that could be improved or done better.

## Stack

* Rails 4.2.7
* Postgres
* Redis
* Sidekiq
* React

## Features

The repo is now open source and serves as a reference for many implementations like -

* Activity feed and notification system with Redis and Postgres,
* Gamification system using redis,
* Redis as secondary data store along with postgres for faster read/writes,
* Multiple social authentication providers,
* Service objects,
* User invitation system using devise,
* Username suggestions,
* Rails engines,
* Faster keyword search with redis,
* Realtime stuff with Pusher,
* Using jobs to offload heavier stuffs,
* And, many other cool things like commenting and voting.

## Environment variabels
The platform uses Google cloud for storing user uploaded assets.
[http://cloud.google.com/](http://cloud.google.com/)

```bash
  ASSET_KEY: ""
  ASSET_SECRET: ""
  ASSET_BUCKET_NAME: ""
  PUSHER_APP_ID: ""
  PUSHER_APP_KEY: ""
  PUSHER_APP_SECRET: ""
  MANDRILL_USERNAME: ''
  MANDRILL_API_KEY: ''
  SKYLIGHT_AUTHENTICATION: ''
  BUGSNAG_API_KEY: ''
  ENABLE_COMPRESSION: '0'
  MIXPANEL_API_KEY: ''
  DB_POOL: '5'
  REDIS_URL: ""
```

## Development

```bash
git clone git@github.com:gauravtiwari/hungryhead.git
cd hungryhead
bundle install

brew install redis
brew install postgresql

bundle exec rake db:drop db:create db:migrate
bundle exec rake db:seed
./start
```
