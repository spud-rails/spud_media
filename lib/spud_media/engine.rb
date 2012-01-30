require 'spud_core'
module Spud
	module Media
		 class Engine < Rails::Engine
			engine_name :spud_media
			initializer :admin do
				Spud::Core.configure do |config|
				  config.admin_applications += [{:name => "Media",:thumbnail => "spud/admin/media_thumb.png",:url => "/spud/admin/media",:order => 3}]
				end
			end
			initializer :assets do |config| 
				Rails.application.config.assets.precompile += [ 
				     "spud/admin/media*"
				]
			 end
		 end
	end
end
