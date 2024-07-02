Rails.application.routes.draw do
  # Custom routes for creating chats and messages
  # These can be nested under their respective resources
  # post 'applications/:application_token/chats', to: 'chats#create'
  # post 'applications/:application_token/chats/:chat_id/messages', to: 'messages#create'

  # Route for searching messages
  get 'messages_search', to: 'messages#search'

  # RESTful routes for applications, chats, and messages
  resources :applications, param: :token, only: [:index, :show, :update, :create] do
    resources :chats, only: [:index, :show, :update, :create] do
      resources :messages, only: [:index, :show, :update, :create]
    end
  end

  # Defines the root path route ("/")
  # Uncomment and customize the root path as needed
  # root "articles#index"
end
