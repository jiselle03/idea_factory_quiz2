Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :ideas do
    resources :reviews
  end

  get('/', { to: 'ideas#index', as: 'root' })

  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
end
