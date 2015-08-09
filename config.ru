# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'action_cable/process/logging'
run ActionCable.server
run Rails.application
