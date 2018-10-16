FactoryBot.define do
  factory :wallet_currency do
    name { "Withdraw" }
    ticker { "BTC" }
    wallet { FactoryBot.create :wallet }
    amount { 1.30000000 }
  end
end
