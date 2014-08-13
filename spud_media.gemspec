$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spud_media/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spud_media"
  s.version     = Spud::Media::VERSION
  s.authors     = ["David Estes"]
  s.email       = ["destes@redwindsw.com"]
  s.homepage    = "http://www.github.com/spud-rails/spud_media"
  s.summary     = "Spud File upload/management module"
  s.description = "Spud Media allows you to upload files to your site and manage them in the spud administrative panel. It also uses paperclip and supports s3 storage"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "Readme.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency 'spud_core', ">= 1.0.0"

  s.add_dependency "paperclip", ">= 4.2.0"

  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'rspec', '2.14.0'
  s.add_development_dependency 'rspec-rails', '2.14.0'
  s.add_development_dependency 'shoulda', '~> 3.0.1'
  s.add_development_dependency 'factory_girl', '~> 3.0'
  s.add_development_dependency 'database_cleaner', '1.0.0.RC1'
  s.add_development_dependency 'mocha', '0.14.0'
  s.add_development_dependency 'simplecov', '~> 0.6.4'
end
