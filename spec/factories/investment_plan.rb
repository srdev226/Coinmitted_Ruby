FactoryBot.define do
  factory :investment_plan do
    title { 'basic' }
    subtitle { Faker::Simpsons.quote }
    description { Faker::Simpsons.quote }
  end
end
