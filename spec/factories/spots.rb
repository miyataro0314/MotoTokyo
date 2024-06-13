FactoryBot.define do
  factory :spot do
    sequence(:name) { |n| "test_spot#{n}" }
    parking { 0 }
    parking_limitation { 0 }
    area { 15 }
    category { 0 }
  end
end
