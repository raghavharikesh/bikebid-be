Rails.application.routes.draw do
  devise_for :users, path: "api/v1/auth", controllers: {
    sessions: "api/v1/auth/sessions",
    registrations: "api/v1/auth/registrations"
  }

  namespace :api do
    namespace :v1 do
      resources :bikes do
        resources :bids, only: [:index, :create]
        member do
          post :end_auction
          get  :inspection_report
        end
      end

      resource :wallet, only: [:show] do
        post :deposit
        post :withdraw
      end

      resources :orders, only: [:index, :show] do
        member { post :pay }
      end

      resources :inspections, only: [:index, :show, :create] do
        member { post :submit_report }
      end

      resources :disputes, only: [:index, :create, :show]
      resources :notifications, only: [:index, :update]

      namespace :admin do
        resources :bikes, only: [:index] do
          member do
            post :approve
            post :reject
          end
        end
        resources :transactions, only: [:index] do
          member { post :approve }
        end
        resources :disputes, only: [:index] do
          member { post :resolve }
        end
        resources :users, only: [:index] do
          member { post :ban }
        end
      end
    end
  end

  mount ActionCable.server => "/cable"
  get "up" => "rails/health#show", as: :rails_health_check
end
