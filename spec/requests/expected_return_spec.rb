require "rails_helper"

RSpec.describe "Expected Return", type: :request do

  let(:investment) { FactoryBot.create(:investment,
                                      invested_amount: 900,
                                      investment_plan_id: FactoryBot.create(:investment_plan).id
                                      ) }
  let(:amount) { 1000 }

  describe "GET /expected_return" do
    #login_user
    before {
      post "/expected_return", params: { investment: investment.attributes }
    }

    it "returns expected earning" do
      expect(response.status).to eq 200
      #expect(json).to eq 4
    end

    it "expect to return amount"

  end
end
