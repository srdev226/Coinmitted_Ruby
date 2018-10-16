FactoryBot.define do
  factory :earning do
    user { FactoryBot.create(:user) }
    amount { 1000 }
    investment { FactoryBot.create(:investment) }
  end
end
