class MessagesController < ApplicationController
  protect_from_forgery with: :null_session # For CSRF issues
  skip_before_action :verify_authenticity_token, only: [:create]
  def create
      redis = Redis.new(url: 'redis://redis:6379/0')
      message = { chat_id: params[:chat_id], number: params[:number], content: params[:content] }
      redis.lpush('golang_messages', message.to_json)
      puts "NEW MESSAGEEEE", message.to_json
      
      render json: { status: 'enqueued message' }, status: :ok
  end
end
