class Friendship < ApplicationRecord
  validates :user_id, uniqueness: { scope: :friend_id, message: 'should have only one friendship per friend' }

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: { pending: 0, approved: 5 }
end
