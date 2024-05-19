class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_many :spots, dependent: :nullify
  has_many :difficulties, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum role: { general: 0, admin: 10 }
end
