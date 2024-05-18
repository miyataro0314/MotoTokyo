module Api
  module V1
    class SpotsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def check
        if !params[:adr_address].include?('東京都')
          render json: { available: false, reason: 'out_of_area' }
        elsif Spot.exists?(name: params[:name])
          render json: { avalable: false, reason: 'already_registered' }
        else
          set_session_spot_details
          render json: { available: true }
        end
      end

      private

      def set_session_spot_details
        session[:name] = params[:name]
        session[:place_id] = params[:place_id]
        session[:postal_code] = params[:adr_address]&.slice(/〒(\d{3}-\d{4})/)
        session[:region] = params[:adr_address]&.slice(%r{<span class="region">(.+)</span><span class}, 1)
        session[:street_address] = params[:adr_address]&.slice(%r{<span class="street-address">(.+)</span>}, 1)
        session[:phone_number] = params[:formatted_phone_number]
        session[:lat] = params.dig(:geometry, :location, :lat)
        session[:lng] = params.dig(:geometry, :location, :lng)
        session[:weekday_text] =
          params.dig(:opening_hours, :weekday_text) || params.dig(:current_opening_hours, :weekday_text)
        session[:rating] = params[:rating]
        session[:user_rating_total] = params[:user_rating_total]
        session[:url] = params[:url]
      end
    end
  end
end