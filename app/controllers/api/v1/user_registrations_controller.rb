module Api
  module V1
    class UserRegistrationsController < BaseController
      def check_id
        if User.exists?(id: params[:id])
          render json: { available: false }
        else
          render json: { available: true }
        end
      end

      def check_email
        if User.exists?(email: params[:email])
          render json: { available: false }
        else
          render json: { available: true }
        end
      end
    end
  end
end
