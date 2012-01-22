require 'spud_admin'
module Spud
	module Template
		 class Engine < Rails::Engine
			engine_name :spud_template
			initializer :admin do
				Spud::Core.configure do |config|
				  config.admin_applications += [{:name => "Template App",:thumbnail => "spud/admin/template_thumb.png",:url => "/spud/admin/template_root",:order => 10}]
				end
			end
			initializer :assets do |config| 
				Rails.application.config.assets.precompile += [ 
				     "spud/admin/template*"
				]
			 end
		 end
	end
end
