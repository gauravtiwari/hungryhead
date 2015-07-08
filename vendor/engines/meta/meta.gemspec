$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "meta/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "meta"
  s.version     = Meta::VERSION
  s.authors     = ["Gaurav Tiwari"]
  s.email       = ["gaurav@gauravtiwari.co.uk"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Meta."
  s.description = "TODO: Description of Meta."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.3"

  s.add_development_dependency "sqlite3"
end
