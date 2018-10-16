FactoryBot.define do
  factory :wallet do
    user { FactoryBot.create :user }
    total_in_usd { 1000 }
  end
end
