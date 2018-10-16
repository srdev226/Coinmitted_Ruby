FactoryBot.define do
  factory :payout_frequency do
    title { "weekly" }
    subtitle { Faker::Hacker.say_something_smart }
    description { Faker::Hacker.say_something_smart }
    promo { "" }
    name { "weekly" }
  end
end
