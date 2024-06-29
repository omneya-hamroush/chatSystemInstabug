class ChatsController < ApplicationController
    protect_from_forgery with: :null_session # For CSRF issues
    skip_before_action :verify_authenticity_token, only: [:create]

    def create
        @chat = Chat.new(chat_params)
        if @chat.save
        # Enqueue chat to be sent to Golang
        enqueue_chat(@chat)
        render json: { status: 'Chat created and enqueued' }, status: :created
        else
        render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def chat_params
        params.require(:chat).permit(:application_id, :number)
    end

    def enqueue_chat(chat)
        conn = Bunny.new
        conn.start
        ch = conn.create_channel
        q = ch.queue('chats')
    
        q.publish(chat.to_json)
        conn.close
        # Code to send the chat data to the Golang app (e.g., via a message queue)
    end
end
