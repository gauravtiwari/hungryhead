#!/bin/bash
cd $STACK_PATH
bundle exec rake bower:install
echo "flushall" | redis-cli