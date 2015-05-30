#!/bin/bash
cd $STACK_PATH
ps xa | grep postgres: | grep $POSTGRESQL_DATABASE | grep -v grep | awk '{print $1}' | sudo xargs kill -9
rake db:drop && rake db:create && rake db:migrate
bundle exec rake db:seed