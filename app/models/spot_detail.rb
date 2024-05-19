class SpotDetail < ApplicationRecord
  belongs_to :spot

  def address
    "東京都#{street_address}"
  end

  def opening_hours
    unless weekday_text.nil?
      op_hours = weekday_text[(Time.zone.today.wday + 6) % 7]
      op_hours&.slice!(5..) || '営業時間：情報なし'
    end
  end
end
