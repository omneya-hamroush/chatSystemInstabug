class ApplicationsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]

    def create
        @application = Application.new(application_params)
        if @application.save
            render json: @application, status: :created
        else
            render json: @application.errors, status: :unprocessable_entity
        end
        end

        private

        def application_params
        params.require(:application).permit(:name)
        end
end
