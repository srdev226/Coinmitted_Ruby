require 'rails_helper'
RSpec.describe UsersHelper, type: :helper do

  describe "HELPERS" do

    let(:user) { FactoryBot.create(:user) }

    it "return currect amount of all investments of user" do
      inv = create(:investment, user_id: user.id, invested_amount: 200)
      expect(user_invested(user)).to eq 200
    end

    it "return currect amount of all investments of user in RUB" do
      Rate.create(from: "RUB", to: "USD", rate: 0.5)
      inv = create(:investment, user_id: user.id, invested_amount: 200, currency: "RUB")
      expect(user_invested(user)).to eq 100
    end

    it "return currect amount of all investments earned of user" do
      Rate.create(from: "RUB", to: "USD", rate: 0.5)
      inv = create(:investment, user_id: user.id, invested_amount: 200, earned: 100, currency: "RUB")
      expect(user_earned(user)).to eq 50
    end
  end
end
