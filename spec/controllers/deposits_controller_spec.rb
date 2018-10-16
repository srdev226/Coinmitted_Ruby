require 'rails_helper'


RSpec.describe DepositsController, type: :controller do

  let(:user) { create :user }
  let(:investment) { create :investment, user_id: user.id }

  let(:valid_attributes) {
    {
      name: "test investment", invested_amount: 1000,
      open_date: Date.parse("2018-08-20"), end_date: Date.parse("2018-09-20"),
      user_id: user.id, investment_plan_id: FactoryBot.create(:investment_plan).id,
      payout_frequency_id: FactoryBot.create(:payout_frequency).id,
      payment_method_id: FactoryBot.create(:payment_method).id, timeframe: 1,
      status: 'draft', currency: "USD"
    }
  }

  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:admin_wallet) { FactoryBot.create(:wallet,user_id: admin.id) }
  let(:admin_attributes) {
    {wallet_id: admin_wallet.id, name: "Withdraw to Bitcoin", ticker: "BTC", address: "asjdfhjhf", amount: 0.00120987, flag: 0 }
  }

  let(:invalid_attributes) {
    { amount: nil, address: nil }
  }


  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      sign_in admin
      deposit = Investment.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it "return fail for normal user" do
      sign_in user
      deposit = Investment.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).not_to be_successful
    end
  end

  #describe "GET #show" do
    #it "returns a success response" do
      #deposit = Deposit.create! valid_attributes
      #get :show, params: {id: deposit.to_param}, session: valid_session
      #expect(response).to be_success
    #end
  #end

  #describe "GET #new" do
    #it "returns a success response" do
      #get :new, params: {}, session: valid_session
      #expect(response).to be_success
    #end
  #end

  describe "GET #edit" do
    it "returns a success response" do
      deposit = Investment.create! valid_attributes
      sign_in admin
      get :edit, params: {id: deposit.id}
      expect(response).to be_successful
    end

    it "returns a fails response if status draft" do
      deposit = Investment.create! valid_attributes
      deposit.status = 'draft'
      get :edit, params: { id: deposit.id}
      expect(response).to be_faulty
    end
  end

  #describe "POST #create" do
    #context "with valid params" do
      #it "creates a new Deposit" do
        #expect {
          #post :create, params: {deposit: valid_attributes}, session: valid_session
        #}.to change(Deposit, :count).by(1)
      #end

      #it "redirects to the created deposit" do
        #post :create, params: {deposit: valid_attributes}, session: valid_session
        #expect(response).to redirect_to(Deposit.last)
      #end
    #end

    #context "with invalid params" do
      #it "returns a success response (i.e. to display the 'new' template)" do
        #post :create, params: {deposit: invalid_attributes}, session: valid_session
        #expect(response).to be_success
      #end
    #end
  #end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { status: 'active' }
      }

      it "updates the requested deposit" do
        inv = Investment.create! valid_attributes
        sign_in admin
        put :update, params: {id: inv.to_param, investment: new_attributes}
        inv.reload
        expect(inv.status).to eq "active"
      end

      it "redirects to the deposit" do
        inv = Investment.create! valid_attributes
        sign_in admin
        put :update, params: {id: inv.to_param, investment: valid_attributes}
        expect(response).to redirect_to(deposits_path)
      end
    end
  end

  #describe "DELETE #destroy" do
    #it "destroys the requested deposit" do
      #deposit = Deposit.create! valid_attributes
      #expect {
        #delete :destroy, params: {id: deposit.to_param}, session: valid_session
      #}.to change(Deposit, :count).by(-1)
    #end

    #it "redirects to the deposits list" do
      #deposit = Deposit.create! valid_attributes
      #delete :destroy, params: {id: deposit.to_param}, session: valid_session
      #expect(response).to redirect_to(deposits_url)
    #end
  #end

end
