FactoryBot.define do
  factory :investment do
    investment_plan { FactoryBot.create :investment_plan }
    name { Faker::FunnyName.name }
    invested_amount { 900 }
    open_date { Date.parse("2018-07-20") }
    end_date { Date.parse("2018-08-20") }
    user_id { FactoryBot.create :user }
    payout_frequency { FactoryBot.create :payout_frequency }
    payment_method { FactoryBot.create :payment_method }
    timeframe { 1 }
    status { 0 }
    user { FactoryBot.create :user }
    earned { 99.0 }
    expected_return { 99.0 }
    investment_earning { 99.0 }
    currency { "USD" }
  end
end
