require 'rails_helper'

RSpec.describe Payout, type: :model do

  describe "Generate" do
    let(:payout) { Payout.create(
      user_id: FactoryBot.create(:user).id,
      status: 0,
      pay_date: Date.today,
      amount: 1000,
      investment_id: FactoryBot.create(:investment).id
    ) }

    it "check reference number" do
      expect(payout.reference_number).not_to be nil
    end

  end
end
