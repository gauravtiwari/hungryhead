$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "site_feedback/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "site_feedback"
  s.version     = SiteFeedback::VERSION
  s.authors     = ["Gaurav Tiwari"]
  s.email       = ["gaurav@gauravtiwari.co.uk"]
  s.homepage    = "https://hungryhead.co"
  s.summary     = "Site feedback engine to collect people feedbacks"
  s.description = "Site feedback engine to collect people feedbacks"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "simple_form"
  s.add_dependency "browser"
  s.add_dependency "devise"
  s.add_dependency "pundit"
  s.add_dependency "metamagic"
  s.add_dependency "unobtrusive_flash"
  s.add_dependency "mail_form"
  s.add_dependency "fog-google"
  s.add_dependency "carrierwave-mimetype-fu"
  s.add_dependency "carrierwave"
end
