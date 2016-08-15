# Hungryhead (Now Demo only)

Hungryhead is a collaborative network for students to share, validate and develop startup ideas with peers and mentors, supported by gamification.

The platform was built on Rails - standard monolith. Currently, this code is used in production for demo purposes only. The source code is now more than a year old and contains many things that could be improved or done better.

## Stack
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
* And, many other cool things like commenting and voting
