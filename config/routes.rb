Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :applications, only: [:create]
  # resources :chats, only: [:create]
  post 'create_chat', to: 'chats#create'


end
