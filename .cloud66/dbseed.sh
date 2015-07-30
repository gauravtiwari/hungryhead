#!/bin/bash
cd $STACK_PATH
redis-cli flushall
bundle exec rake environment db:drop && bundle exec rake db:create && bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake db:seed_questions