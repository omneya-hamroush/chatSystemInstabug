class MessagesController < ApplicationController
  protect_from_forgery with: :null_session # For CSRF issues
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_chat

  def create
      redis = Redis.new(url: 'redis://redis:6379/0')
      message = { chat_id: params[:chat_id], content: params[:content] }
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
    query = params[:query]

    Rails.logger.debug "Chat ID: #{chat_id}"
    Rails.logger.debug "CONTENT: #{query}"

    search_definition = {
      query: {
        bool: {
          must: [
            { term: { chat_id: chat_id } },
            { match: { content: query } }
          ]
        }
      }
    }

    logger.info "Elasticsearch query: #{search_definition.to_json}"
    results = Message.search(search_definition).records
    puts "RESSSSSSSSSSSSSSS", results

    render json: results
  end



  def index
    @messages = @chat.messages
    render json: @messages.as_json(only: [:number, :body, :created_at, :updated_at])
  end

  def show
    @message = @chat.messages.find(params[:id])
    render json: @message.as_json(only: [:number, :body, :created_at, :updated_at])
  end

  def update
    @message = @chat.messages.find(params[:id])
    if @message.update(message_params)
      render json: @message.as_json(only: [:number, :body, :created_at, :updated_at])
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
