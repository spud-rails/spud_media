Rails.application.routes.draw do
	namespace :spud do
		namespace :admin do
			resources :media
		end
	end

  if Spud::Media.config.protected_media
    get '/protected/media/:id/:filename' => 'ProtectedMedia#show', :as => 'protected_media'
  end
end