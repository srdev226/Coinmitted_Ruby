require "rails_helper"

RSpec.describe InvestmentsController, type: :controller do

  let(:user) { FactoryBot.create(:user, role: "user") }
  let(:profile) { FactoryBot.create(:profile, user_id: user.id) }
  let(:inv) { FactoryBot.create(:investment, user_id: user.id) }
  let(:admin) { FactoryBot.create(:user, role: "admin") }
  let(:valid_attributes) {
    {
      name: "test investment", invested_amount: 1000,
      open_date: Date.parse("2018-07-20"), end_date: Date.parse("2018-08-20"),
      user_id: user.id, investment_plan_id: FactoryBot.create(:investment_plan).id,
      payout_frequency_id: FactoryBot.create(:payout_frequency).id,
      payment_method_id: FactoryBot.create(:payment_method).id, timeframe: 1,
      status: 1, currency: "USD"
    }
  }

  before :each do
    user.profile = profile
  end

  describe "DELETE investment" do

    it "USER can't delete the investment" do
      investment = Investment.create! valid_attributes
      sign_in user
      expect{
        delete :destroy, params: { id: investment.id, user_id: user.id }
      }.to change(Investment,:count).by(0)
    end

  end
  describe "DELETE will not delete if investment not finished" do
  let(:valid_attributes) {
    {
      name: "test investment", invested_amount: 1000,
      open_date: Date.today - 10.day, end_date: Date.today + 20.day,
      user_id: user.id, investment_plan_id: FactoryBot.create(:investment_plan).id,
      payout_frequency_id: FactoryBot.create(:payout_frequency).id,
      payment_method_id: FactoryBot.create(:payment_method).id, timeframe: 1,
      status: 1, currency: "USD"
    }
  }
    it "should not delete if investment not finished" do
      investment = Investment.create! valid_attributes
      sign_in user
      expect{
        delete :destroy, params: { id: investment.id, user_id: user.id }
      }.to change(Investment,:count).by(0)
    end
    it "should delete under admin role" do
      investment = Investment.create! valid_attributes
      sign_in admin
      expect{
        delete :destroy, params: { id: investment.id, user_id: user.id }
      }.to change(Investment,:count).by(-1)
    end
  end

end
