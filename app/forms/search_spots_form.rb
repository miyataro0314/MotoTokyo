class SearchSpotsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :area, :string
  attribute :category, :string
  attribute :parking, :string

  def search
    spots = Spot.all.includes(:spot_detail)

    spots = spots.by_area(area) if area.present?
    spots = spots.by_category(category) if category.present?
    spots = spots.by_parking(parking) if parking.present?

    spots
  end
end
