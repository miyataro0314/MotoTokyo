class Comment < ApplicationRecord
  validates :user_id, uniqueness: { scope: :spot_id }
  validates :content, presence: true

  belongs_to :user
  belongs_to :spot
end
