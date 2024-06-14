FactoryBot.define do
  factory :profile do
    sequence(:user_name) { |n| "test_profile#{n}" }
    sequence(:vehicle_name) { |n| "test_vehicle#{n}" }
    vehicle_type { 0 }
  end
end
