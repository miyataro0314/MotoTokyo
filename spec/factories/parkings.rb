FactoryBot.define do
  factory :parking do
    sequence(:name) { |n| "test_parking#{n}" }
    postal_code { '〒160-0023' }
    address { '新宿区西新宿２丁目５' }
    coordinate { "POINT(139.693724 35.690699)" }
    fee { '07:00~22:00 最初の1時間無料 以降1時間100円 / 入庫当日24時まで最大料金800円' }
    closed_days { nil }
    opening_hours { '入庫可能時間(07:00~22:00) / 出庫可能時間(00:00~24:00)' }
    capacity { '43台' }
    limitation { nil }
    url { 'https://maps.app.goo.gl/LACY1NVMDpbR8ujR9' }
  end
end
