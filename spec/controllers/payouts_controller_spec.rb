require 'rails_helper'

RSpec.describe PayoutsController, type: :controller do

  let(:payout) {
    Payout.create(
      user_id: FactoryBot.create(:user).id,
      status: 0,
      pay_date: Date.today.at_beginning_of_month.next_month,
      amount: 300,
      investment_id: FactoryBot.create(:investment).id
    )
  }

  describe "GET #index" do
    login_user
    it "returns http success" do
      get :index
      expect(response.code).to eq "200"
    end
  end

  describe "GET #show" do
    login_user
    it "returns http success" do
      get :show, params: {id: payout.id}
      expect(response.code).to eq "200"
    end
  end

end
