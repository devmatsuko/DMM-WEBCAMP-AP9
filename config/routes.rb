Rails.application.routes.draw do
  devise_for :users
  # User関連
  resources :users,only: [:show,:index,:edit,:update] do
    # URL:/user/:user_id/relationships
    resource :relationships, only: [:create, :destroy]
    # フォロー一覧、フォロワー一覧へのルーティング
    # memberを書くことでURLにidが加わる。ex)/users/:id/following
    member do
      get :following, :followers
    end
  end
  
  # Book関連
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  
  # チャットルーム関連
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show]
  
  root 'homes#top'
  get 'home/about' => 'homes#about', as: 'about'
  get '/search' => 'searchs#search', as: 'search'
end