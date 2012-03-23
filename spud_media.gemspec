$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spud_media/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spud_media"
  s.version     = Spud::Media::VERSION
  s.authors     = ["David Estes"]
  s.email       = ["destes@redwindsw.com"]
  s.homepage    = "http://www.github.com/davydotcom/spud_media"
  s.summary     = "Spud File upload/management module"
  s.description = "Spud Media allows you to upload files to your site and manage them in the spud administrative panel. It also uses paperclip and supports s3 storage"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "spud_core", ">= 0.8.0", "< 0.9.0"
  s.add_dependency "paperclip", ">= 0"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'factory_girl', '2.5.0'
  s.add_development_dependency 'mocha', '0.10.3'
  s.add_development_dependency "database_cleaner", "0.7.1"
end
