Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :ideas

  get('/', { to: 'ideas#index', as: 'ideas_path' })
end
