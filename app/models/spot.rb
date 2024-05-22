class Spot < ApplicationRecord
  include AreaEnum

  belongs_to :user, optional: true

  has_many :difficulties, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :edit_histories, dependent: :destroy
  has_one :spot_detail, dependent: :destroy

  enum parking: { free: 0, paid: 5, nothing: 10 }
  enum parking_limitation: { all_ok: 0, no_big: 5, only_scooter: 10 }
  enum category: { sightseeing: 0, scenery: 5, shopping: 10, food: 15, activity: 20, accommodations: 25 }

  scope :by_area, ->(area) { where(area:) }
  scope :by_category, ->(category) { where(category:) }
  scope :by_parking, ->(parking) { where(parking:) }
end
