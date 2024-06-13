FactoryBot.define do
  factory :user do
    sequence(:id) { |n| "test_user#{n}" }
    sequence(:email) { |n| "test_user#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
