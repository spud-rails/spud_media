require 'spud_core'
require 'paperclip'
module Spud
	module Media
		 class Engine < Rails::Engine
			engine_name :spud_media
			initializer :admin do
				Spud::Core.append_admin_javascripts('spud/admin/media/application')
  			Spud::Core.append_admin_stylesheets('spud/admin/media/application')
				Spud::Core.configure do |config|
				  config.admin_applications += [{:name => "Media",:thumbnail => "spud/admin/media_thumb.png",:url => "/spud/admin/media",:order => 3,:retina => true}]
				end
			end
		 end
	end
end
