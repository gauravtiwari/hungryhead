#!/bin/bash
cd $STACK_PATH
ps xa | grep postgres: | grep $POSTGRESQL_DATABASE | grep -v grep | awk '{print $1}' | sudo xargs kill -9
bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate