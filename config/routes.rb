Rails.application.routes.draw do
	namespace :spud do
		namespace :admin do
			resources :media do
        put 'set_access', :on => :member
      end
		end
	end

  get '/media/protected/:id/:filename' => 'ProtectedMedia#show', :as => 'protected_media'
  #get Spud::Media.config.storage_url => 'ProtectedMedia#show', :as => 'protected_media'
end