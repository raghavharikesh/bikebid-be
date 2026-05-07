Rails.application.routes.draw do
  devise_for :users, path: "api/v1/auth", controllers: {
    sessions:      "api/v1/auth/sessions",
    registrations: "api/v1/auth/registrations"
  }

  namespace :api do
    namespace :v1 do

      # User profile & settings
      get    "users/profile",         to: "users#profile"
      patch  "users",                 to: "users#update"
      get    "users/wallet",          to: "users#wallet"
      post   "users/change_password", to: "users#change_password"
      patch  "users/mark_read",       to: "users#mark_read"
      get    "users/show_settings",   to: "users#show_settings"
      post   "users/settings",        to: "users#settings"

      # Bikes
      resources :bikes do
        collection do
          get  :mylistings
          get  :buyer_bikes
          get  :nearby_technicians
          get  :check_vin
          get  :makes
          get  :models
          get  :trims
          post :add_bundle
        end
        member do
          post :end_auction
          get  :inspection_report
        end

        resources :bids, only: [:index, :create, :destroy] do
          member do
            post :accept
            post :reject
          end
        end

        resources :disputes, only: [:create, :update, :destroy]
        resources :bike_questions, only: [:index, :create, :update]
        resources :reviews, only: [:create]
      end

      # Wallet
      resource :wallet, only: [:show] do
        post :deposit
        post :withdraw
      end

      # Orders
      resources :orders, only: [:index, :show] do
        member { post :pay }
      end

      # Inspections
      resources :inspections, only: [:index, :show, :create, :update] do
        member { post :submit_report }
      end

      # Disputes (user-level listing)
      resources :disputes, only: [:index, :show]

      # Notifications
      resources :notifications, only: [:index, :update]

      # Technician dashboard
      get "technicians/mylistings", to: "technicians#mylistings"

      # Admin namespace
      namespace :admin do
        get  "dashboard",            to: "dashboard#show"

        resources :bikes, only: [:index] do
          member do
            post :approve
            post :reject
            patch :qa_disable
            post :mark_sold
            post :add_slot
          end
        end

        resources :users, only: [:index, :create, :update] do
          collection { get :admin_users }
          member do
            post :ban
            delete :cancel_subscription
            post :set_subscription
          end
        end

        resources :inspections, only: [:index] do
          member { post :approve }
        end

        resources :disputes, only: [:index, :update, :destroy] do
          member { post :resolve }
        end

        resources :transactions, only: [:index] do
          member do
            post :approve
            post :reject
          end
        end

        resources :technicians, only: [:index]

        resources :wallets, only: [] do
          member do
            post :credit
            post :debit
          end
        end
      end

    end
  end

  mount ActionCable.server => "/cable"
  get "up" => "rails/health#show", as: :rails_health_check
end
