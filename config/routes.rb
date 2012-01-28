Rails.application.routes.draw do
	namespace :spud do
		namespace :admin do
			resources :media
		end
	end
   
end

