class SearchSpotsForm
  # includeによりActive Recordモデルのような機能を持たせつつ、データベーステーブルに依存しない独立したオブジェクトとして動作させる
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :area, :string
  attribute :category, :string
  attribute :parking, :string

  # gemを使用しないで検索機能を実装
  def search
    spots = Spot.all.includes(:spot_detail)

    spots = spots.by_area(area) if area.present?
    spots = spots.by_category(category) if category.present?
    spots = spots.by_parking(parking) if parking.present?

    spots
  end
end
