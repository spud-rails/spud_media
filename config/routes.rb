Rails.application.routes.draw do
	namespace :spud do
		namespace :admin do
			resources :media do
		        put 'set_access', :on => :member
		        get 'replace', :on => :member
			end
			resources :media_picker, :only => [:index, :create]
		end
	end

  #get '/media/protected/:id/:style/:filename' => 'ProtectedMedia#show', :as => 'protected_media'
  get Spud::Media.config.storage_url => 'protected_media#show', :as => 'protected_media'
end
