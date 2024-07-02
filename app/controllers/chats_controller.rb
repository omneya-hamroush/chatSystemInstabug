class ChatsController < ApplicationController
    protect_from_forgery with: :null_session # For CSRF issues
    skip_before_action :verify_authenticity_token, only: [:create]
    before_action :set_application
    before_action :set_chat, only: [:show, :update]

    def create
        redis = Redis.new(url: 'redis://redis:6379/0')
        chat = { token: params[:application_token] }
        redis.lpush('golang_chats', chat.to_json)
        puts "NEW C?HATTTTTTTTTTTTtt", chat.to_json
        
        render json: { status: 'enqueued' }, status: :ok
    end

    
    def index
        @chats = @application.chats
        render json: @chats.as_json(only: [:number, :messages_count, :created_at, :updated_at])
    end

    def show
        render json: @chat.as_json(only: [:number, :messages_count, :created_at, :updated_at])
    end

    def update
        if @chat.update(chat_params)
        render json: @chat.as_json(only: [:number, :messages_count, :created_at, :updated_at])
        else
        render json: @chat.errors, status: :unprocessable_entity
        end
    end

    private

    def set_application
        @application = Application.find_by!(token: params[:application_token])
    end

    def set_chat
        @chat = @application.chats.find(params[:id])
    end

    def chat_params
        params.require(:chat).permit(:number)
    end
    # def create
    #     chat = Chat.new(chat_params)

    #     if chat.save
    #         # Enqueue the chat for processing in Golang via Redis
    #         redis = Redis.new(url: 'redis://redis:6379/0')  # Adjust URL based on Docker Compose setup
    #         redis.lpush('golang_chats', { application_id: chat.application_id, number: chat.number }.to_json)

    #         render json: { message: 'Chat created and enqueued' }

    #         # redis = Redis.new(url: 'redis://redis:6379/0')  # Adjust URL based on Docker Compose setup

    #         # while true do
    #         #     result = redis.brpop(10, 'golang_chats')
    #         #     if result
    #         #         chat_data = JSON.parse(result[1])
    #         #         puts "Received chat: #{chat_data}"
    #         #         # Process the chat data
    #         #         render json: { message: 'Chat enqueued and dequeued' }
    #         #     else
    #         #         puts "No messages found in queue 'golang_chats'"
    #         #     end
    #         # end
    #     else
    #         render json: { errors: chat.errors.full_messages }, status: :unprocessable_entity
    #     end
    #     end

    #     private

    #     def chat_params
    #     params.require(:chat).permit(:application_id, :number)
    #     end
end
