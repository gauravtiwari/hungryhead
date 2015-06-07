#!/bin/bash
cd $STACK_PATH
bundle exec rake bower:install
redis-cli flushall