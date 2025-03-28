Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :subscriptions, only: [:index, :show, :update]
      resources :teas, only: [:index, :show, :create]
      resources :customers, only: [:index, :show]
    end
  end
end
