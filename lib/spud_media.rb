module Spud
	module Media
		require 'spud_media/configuration'
    require 'responds_to_parent.rb'
		require 'spud_media/engine' if defined?(Rails)
	end
end
