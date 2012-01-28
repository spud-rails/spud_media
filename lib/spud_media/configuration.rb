module Spud
  module Media
    include ActiveSupport::Configurable
    config_accessor :paperclip_storage,:s3_credentials
    self.paperclip_storage = :filesystem
    self.s3_credentials = "#{Rails.root}/config/s3.yml"
  end
end