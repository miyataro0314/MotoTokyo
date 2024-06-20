FactoryBot.define do
  factory :notification do
    sequence(:title) { |n| "test_title#{n}" }
    sequence(:message) { |n| "test_message#{n}" }
    url { '/' }
    notification_type { 0 }
  end
end
