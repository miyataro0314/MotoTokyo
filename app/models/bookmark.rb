class Bookmark < ApplicationRecord
  validates :user_id, uniqueness: { scope: :spot_id, message: 'should have only one bookmark per spot' }

  belongs_to :user
  belongs_to :spot
end
