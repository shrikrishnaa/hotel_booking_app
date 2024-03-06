Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :hotels do
    collection do
      get :filter_by_location
    end
  end
  
  resources :bookings, only: [:create, :update, :destroy, :show, :index] do
    collection do
      get :user_bookings
    end
  end
  
  # Defines the root path route ("/")
  # root "articles#index"
end
