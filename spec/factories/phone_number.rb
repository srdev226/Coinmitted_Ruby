FactoryBot.define do
  factory :phone_number do
    number { '338383394' }
    verified { false }
    deleted { false }
    profile_id { FactoryBot.create :profile }
    full_number { "+61412567876" }
  end
end
