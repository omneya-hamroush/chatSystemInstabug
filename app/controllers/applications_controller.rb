class ApplicationsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :update]

    before_action :set_application, only: [:show, :update]

    def index
        @applications = Application.all
        render json: @applications.as_json(only: [:name, :token, :chats_count, :created_at, :updated_at])
    end

    def show
        render json: @application.as_json(only: [:name, :token, :chats_count, :created_at, :updated_at])
    end

    def create
        @application = Application.new(application_params)
        if @application.save
            render json: @application.as_json(only: [:name, :token, :chats_count, :created_at, :updated_at])
        else
            render json: @application.errors, status: :unprocessable_entity
        end
        end

        

        

    def update
        if @application.update(application_params)
            render json: @application
        else
            render json: @application.errors, status: :unprocessable_entity
        end
    end

    private

    def set_application
        @application = Application.find_by!(token: params[:token])
    end

    def application_params
        params.require(:application).permit(:name)
    end
    def application_params
        params.require(:application).permit(:name)
    end
    
end
