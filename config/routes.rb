Rails.application.routes.draw do
  root "posts#index"

  resources :posts, only: %i[index show create]
  resources :users, only: %i[new create show]

  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  delete 'log_out', to: 'sessions#destroy'

  # Should let people update / restore their passwords, so there'd be paths for that
  #  But that can wait till later
end
