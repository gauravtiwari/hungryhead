#!/bin/bash
cd $STACK_PATH
bundle exec rake db:seed
bundle exec rake bower:install