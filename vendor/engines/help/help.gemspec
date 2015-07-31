$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "help/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "help"
  s.version     = Help::VERSION
  s.authors     = ["Gaurav Tiwari"]
  s.email       = ["gaurav@gauravtiwari.co.uk"]
  s.homepage    = "https://hungryhead.co"
  s.summary     = "Help Engine to show help pages"
  s.description = "Help Engine to show help pages"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"

  s.add_dependency "simple_form"
  s.add_dependency "friendly_id"
  s.add_dependency "browser"
  s.add_dependency "devise"
  s.add_dependency "metamagic"
  s.add_dependency "pundit"
  s.add_dependency "postgres-copy"

  s.add_development_dependency "sqlite3"
end
