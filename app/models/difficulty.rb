class Difficulty < ApplicationRecord
  validates :user_id, uniqueness: { scope: :spot_id, message: 'should have only one difficulty per spot' }
  validates :level, presence: true

  belongs_to :user
  belongs_to :spot

  enum level: {
    easy: 0,
    traffic: 5,
    direction: 10,
    condition: 15
  }

  def self.percentage(spot, level)
    total_count = Difficulty.where(spot:).count
    return 0 if total_count.zero?

    level_count = Difficulty.where(spot:, level:).count
    (level_count.to_f / total_count * 100).round
  end
end
