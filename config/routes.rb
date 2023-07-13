Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'sales#index'

  resources :sales do
    collection { post :import }
  end

  resources :transactions, only: [:index, :create] do
    collection { post :import }
  end
end
