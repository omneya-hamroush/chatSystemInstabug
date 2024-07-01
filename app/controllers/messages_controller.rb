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

  # def search
  #   chat_id = params[:chat_id]
  #   query = params[:q]

  #   if chat_id.present?
  #     messages = Message.search(query, where: { chat_id: chat_id }).records.to_a
  #   else
  #     messages = Message.search(query).records.to_a
  #   end

  #   render json: messages
  # end
  def search
    chat_id = params[:chat_id]
    # query = params[:query]

    Rails.logger.debug "Chat ID: #{chat_id}"
    results = Message.search({
      query: {
        bool: {
          must: [
            { match: { chat_id: chat_id } },
            # { match: { body: query } }
          ]
        }
      }
    }).records
    puts "RESSSSSSSSSSSSSSS", results

    render json: results
  end
end
