#!/bin/bash
cd $STACK_PATH
bundle exec rake db:reset
bundle exec rake db:seed