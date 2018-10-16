FactoryBot.define do
  factory :payout do
    user { FactoryBot.create(:user) }
    status { 0 }
    pay_date { Date.today }
    amount { 0 }
    investment { FactoryBot.create(:investment) }
  end
end
