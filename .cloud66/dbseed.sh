#!/bin/bash
cd $STACK_PATH
bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate
bundle exec rake db:seed