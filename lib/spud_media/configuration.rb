module Spud
  module Media
    include ActiveSupport::Configurable
    config_accessor :paperclip_storage,:s3_credentials,:storage_path,:storage_url
    self.paperclip_storage = :filesystem
    self.s3_credentials = "#{Rails.root}/config/s3.yml"
    self.storage_path = "public/system/:class/:id/attachment/:basename.:extension"
    self.storage_url = "/system/:class/:id/attachment/:basename.:extension"
  end
end