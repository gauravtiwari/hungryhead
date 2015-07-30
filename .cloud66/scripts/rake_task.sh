#!/bin/bash
cd $STACK_PATH
redis-cli flushall
bundle exec rake db:seed_questions