class Spot < ApplicationRecord
  include ParkingEnum
  include CategoryEnum
  include AreaEnum

  validates :name, presence: true, uniqueness: true
  validates :parking, presence: true
  validates :category, presence: true
  validates :area, presence: true

  belongs_to :user, optional: true
  has_many :difficulties, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :edit_histories, dependent: :destroy
  has_many :access_histories, dependent: :destroy
  has_one :spot_detail, dependent: :destroy

  enum parking_limitation: { all_ok: 0, no_big: 5, only_scooter: 10 }

  scope :by_area, ->(area) { where(area:) }
  scope :by_category, ->(category) { where(category:) }
  scope :by_parking, ->(parking) { where(parking:) }
  scope :nearby, lambda { |point, distance|
    joins(:spot_detail)
      .where('ST_DWithin(coordinate, ST_GeomFromText(?, 4326), ?)', point.to_s, distance)
      .order(Arel.sql('ST_Distance(coordinate, ST_GeomFromText(?, 4326))', point.to_s))
  }

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def hashtag_for_tweet
    hashtags = {
      'sightseeing' => '#東京観光 #東京散策 #東京名所',
      'scenery' => '#東京景色 #東京風景',
      'shopping' => '#東京ショッピング #東京お土産',
      'food' => '#東京グルメ',
      'activity' => '#東京体験 #東京アクティビティ',
      'accommodations' => '#東京宿泊 #東京ホテル'
    }

    hashtags[category]
  end
end
