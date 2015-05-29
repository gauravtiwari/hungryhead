# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::CanonicalHost do |env|
  case env['RACK_ENV'].to_sym
    when :staging then ENV['CANONICAL_HOST']
    when :production then ENV['CANONICAL_HOST']
  end
end

run Rails.application
