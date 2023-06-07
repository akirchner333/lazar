Rails.application.routes.draw do
  root "static#landing"

  # --------------- ActivityPub ----------------------
  scope module: 'pub' do
    get '/.well-known/webfinger', to: 'finger#webfinger'
    post '/inbox', to: 'inbox#inbox'
  end

  namespace :pub do
    get '/actor/:id', to: 'actor#actor'
    get '/test', to: 'inbox#test'
    post '/reply', to: 'actor#reply'
    post '/inbox', to: 'inbox#inbox'
  end

  if ENV['SITE_LIVE'] != 'true'
    get '*path', to: redirect('/')
  end

  resources :posts, only: %i[index show create]
  get '/posts/:id/replies', to: 'posts#replies'
  get '/posts/:id/plies', to: 'posts#plies'
  resources :users, only: %i[new create update show]

  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'

  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  delete 'sign_out', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#omniauth'

  resources :likes, only: %i[create]
  get 'likes/:reaction', to: 'likes#user_index', as: 'user_likes'
  delete 'likes', to: 'likes#destroy'
  get ':user/likes/:reaction', to: 'likes#index'

  get 'random', to: 'posts#random'

  get 'help', to: 'static#help'
  get 'museum', to: 'static#museum'

  

  # Should let people update / restore their passwords, so there'd be paths for that
  # Until then, we lose access to our accounts like men
end
