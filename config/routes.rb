Rails.application.routes.draw do
  root "static#landing"

  # --------------- ActivityPub ----------------------
  scope module: 'pub' do
    get '/.well-known/webfinger', to: 'finger#webfinger'
    post '/inbox', to: 'inbox#inbox'
  end

  namespace :pub do
    get '/actor/:id', to: 'actor#actor'
    get '/actor/:id/collections/featured', to: 'actor#featured'
    get '/actor/:id/collections/followers', to: 'actor#followers'
    get '/actor/:id/collections/following', to: 'actor#following'
    post '/reply', to: 'actor#reply'
    post '/inbox', to: 'inbox#inbox'
    get '/outbox', to: "inbox#outbox"
  end

  resources :posts, only: %i[index show create destroy]
  get 'posts/:id/new', to: 'posts#new'
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
  get 'rotate', to: 'static#rotate'

  

  # Should let people update / restore their passwords, so there'd be paths for that
  # Until then, we lose access to our accounts like men
end
