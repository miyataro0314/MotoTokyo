class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_many :spots, dependent: :nullify
  has_many :difficulties, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :edit_histories, dependent: :destroy
  has_one :profile, dependent: :destroy

  has_many :bookmarked_spots, through: :bookmarks, source: :spot

  enum role: { general: 0, admin: 10 }
end
