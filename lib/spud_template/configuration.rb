module Spud
  module Template
    include ActiveSupport::Configurable

    config_accessor :template_config_option
    self.template_config_option = "default value"
    
  end
end