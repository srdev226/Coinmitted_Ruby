FactoryBot.define do
  factory :payment_method do
    name { Faker::FunnyName.name }
    ticker { "btc" }
  end
end
