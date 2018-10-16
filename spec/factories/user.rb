FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 'user' }
  end
end
