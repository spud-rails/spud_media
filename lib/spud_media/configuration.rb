module Spud
  module Media
    include ActiveSupport::Configurable
    config_accessor :paperclip_storage,:s3_credentials,:storage_path,:storage_path_protected,:storage_url
    self.paperclip_storage = :filesystem
    self.s3_credentials = "#{Rails.root}/config/s3.yml"
    self.storage_path = "public/system/spud_media/:id/:style/:basename.:extension"
    self.storage_path_protected = "public/system/spud_media_protected/:id/:style/:basename.:extension"
    self.storage_url = "/system/spud_media/:id/:style/:basename.:extension"
  end
end