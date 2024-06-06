class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates :id, presence: true, uniqueness: true, length: { minimum: 6, maximum: 30 }
  validates :email, presence: true, uniqueness: true

  has_many :spots, dependent: :nullify
  has_many :difficulties, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_spots, through: :bookmarks, source: :spot
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend
  has_many :edit_histories, dependent: :destroy
  has_many :access_histories, dependent: :destroy
  has_many :search_histories, dependent: :destroy
  has_one :profile, dependent: :destroy

  enum role: { general: 0, admin: 10 }

  def already_commented?(spot)
    comments.exists?(spot_id: spot.id)
  end

  def comment_for(spot)
    comments.find_by(spot_id: spot.id)
  end

  def difficulty_for(spot)
    difficulties.find_by(spot_id: spot.id)
  end

  def friendship_status_with(other_user)
    friendship = friendships.find_by(friend: other_user)
    return 'false' unless friendship

    case friendship.status
    when 'approved'
      'approved'
    when 'pending'
      'pending'
    end
  end

  def approved_friends
    User.joins(:friendships).where(friendships: { friend_id: id, status: :approved })
  end

  def friend_requests
    Friendship.where(friend_id: id, status: :pending)
  end
end
