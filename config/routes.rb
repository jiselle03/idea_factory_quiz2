Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :ideas do
    resources :reviews
    resources :likes, shallow: true, only: [:create, :destroy]
  end

  get('/', { to: 'ideas#index', as: 'root' })

  resources :users, except: [:destroy]
  resource :session, only: [:new, :create, :destroy]

  get('/users/:id/password/edit', { to: 'users#edit_password', as: 'edit_password' })
  patch('/users/:id/password/edit', { to: 'users#update_password', as: 'update_password'})
end
