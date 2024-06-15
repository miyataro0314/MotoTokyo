class Bookmark < ApplicationRecord
  validates :user_id, uniqueness: { scope: :spot_id }

  belongs_to :user
  belongs_to :spot
end
