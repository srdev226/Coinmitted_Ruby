FactoryBot.define do
  factory :profile do
    user { FactoryBot.create :user }
    name { Faker::FunnyName.name }
    bio { Faker::Lorem.paragraph }
    gender { 1 }
    language { "en" }
    currency { "USD" }
    country { "rus" }
    member { "basic" }
    notification_news { true }
    notification_deposit { true }
    notification_payout { true }
    notification_alert { true }
    deleted { false }
    wallet_pin_enabled { true }
    wallet_pin { 1234 }
    balance { 100 }
  end
end
