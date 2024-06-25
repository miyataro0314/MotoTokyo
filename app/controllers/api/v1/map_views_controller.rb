module Api
  module V1
    class MapViewsController < BaseController
      def fetch_map_data
        @spots = Spot.includes(:spot_detail)
        @parkings = Parking.all

        filter_spots
        render json: { spots: @spots.as_json(include: :spot_detail), parkings: @parkings }
      end

      private

      def build_point(lng, lat)
        factory = RGeo::Geographic.spherical_factory(srid: 4326)
        factory.point(lng, lat)
      end

      def filter_spots
        return unless params[:query]

        area = params[:query][:area]
        category = params[:query][:category]
        parking = params[:query][:parking]

        @spots = @spots.by_area(area) if area.present?
        @spots = @spots.by_category(category) if category.present?
        @spots = @spots.by_parking(parking) if parking.present?
      end
    end
  end
end
