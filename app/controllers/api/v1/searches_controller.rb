module Api
  module V1
    class SearchesController < BaseController
      def load_map_data
        @spots = Spot.includes(:spot_detail)
        @parkings = Parking.all
        render json: { spots: @spots.as_json(include: :spot_detail), parkings: @parkings }
      end

      private

      def build_point(lng, lat)
        factory = RGeo::Geographic.spherical_factory(srid: 4326)
        factory.point(lng, lat)
      end
    end
  end
end
