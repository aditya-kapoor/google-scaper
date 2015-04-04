Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :keywords

  namespace :api do
    namespace :v1 do
      resources :keywords, only: [] do
        post :import, on: :collection
      end
    end
  end

  root to: 'keywords#index'
end
