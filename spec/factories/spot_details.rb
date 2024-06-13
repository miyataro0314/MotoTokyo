FactoryBot.define do
  factory :spot_detail do
    sequence(:id) { |n| "test_spot_detail#{n}" }
    postal_code { "〒123-4567" }
    street_address { '新宿区西新宿２丁目８−１' }
    coordinate { "POINT(139.6916863 35.6894807)" }
    weekday_text { [
      "月曜日: 9時00分～22時30分",
      "火曜日: 9時00分～22時30分",
      "水曜日: 9時00分～22時30分",
      "木曜日: 9時00分～22時30分",
      "金曜日: 9時00分～22時30分",
      "土曜日: 24 時間営業",
      "日曜日: 24 時間営業"] }
    rating { 5.0 }
    user_rating_total { 100 }
    url { 'https://maps.google.com/?cid=17394692006143746536' }
  end
end
