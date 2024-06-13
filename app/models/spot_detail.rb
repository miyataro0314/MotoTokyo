class SpotDetail < ApplicationRecord
  validates :id, presence: true, uniqueness: true
  validates :spot_id, uniqueness: true

  belongs_to :spot

  def address
    "東京都#{street_address}"
  end

  def opening_hours
    return '営業時間情報なし' if weekday_text.nil?

    op_hours = weekday_text[(Time.zone.today.wday + 6) % 7]
    op_hours&.slice!(5..) || '営業時間：情報なし'
  end
end
