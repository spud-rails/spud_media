Rails.application.routes.draw do
	namespace :spud do
		namespace :admin do
			resources :media
		end
	end

  #get '/media/:id/:filename' => 'ProtectedMedia#show', :as => 'protected_media'
  get Spud::Media.config.storage_url => 'ProtectedMedia#show', :as => 'protected_media'
end