# desc "Explaining what the task does"
# task :spud_media do
#   # Task goes here
# end

namespace :spud_media do

  desc "Validate that all media files have the proper permission settings"
  task :validate_permissions => :environment do
    SpudMedia.find_each do |m|
      m.validate_permissions
    end
  end

end