Spud::Core::Engine.routes.draw do
  scope :module => "spud" do
    namespace :admin do
      resources :media do
        put 'set_access', :on => :member
      end
      resources :media_picker, :only => [:index, :create]
    end
  end
end

Spud::Media::Engine.routes.draw do
  get Spud::Media.config.storage_url => 'ProtectedMedia#show', :as => 'protected_media'
end

Rails.application.routes.draw do
	if Spud::Media.config.automount
    mount Spud::Media::Engine, :at => "/"
  end
end
