class Difficulty < ApplicationRecord
  validates :level, presence: true

  belongs_to :user
  belongs_to :spot

  enum level: {
    easy: 0,
    traffic: 5,
    direction: 10,
    condition: 15
  }
end
