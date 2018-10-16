require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do

  let(:user) { create :user }
  let(:wallet) { create :wallet, user_id: user.id }

  let(:valid_attributes) {
    {wallet_id: wallet.id, name: "Withdraw to Bitcoin", ticker: "BTC", address: "asjdfhjhf", amount: 0.00120987, flag: 0 }
  }

  let(:invalid_attributes) {
    { amount: nil, address: nil }
  }


  let(:admin) { FactoryBot.create(:user, role: 'admin') }
  let(:admin_wallet) { FactoryBot.create(:wallet,user_id: admin.id) }
  let(:admin_attributes) {
    {wallet_id: admin_wallet.id, name: "Withdraw to Bitcoin", ticker: "BTC", address: "asjdfhjhf", amount: 0.00120987, flag: 0 }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      transaction = Transaction.create! admin_attributes
      sign_in admin
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    it "return false for normal user" do
      transaction = Transaction.create! valid_attributes
      sign_in user
      get :index, params: {}
      expect(response).not_to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      transaction = Transaction.create! admin_attributes
      sign_in admin
      get :show, params: {id: transaction.to_param}, session: valid_session
      expect(response).to be_successful
    end

    it "return false respose with normal user" do
      transaction = Transaction.create! valid_attributes
      sign_in user
      get :show, params: {id: transaction.to_param}, session: valid_session
      expect(response).not_to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      sign_in user
      get :new, params: {wallet_id: wallet.id}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      transaction = Transaction.create! admin_attributes
      sign_in admin
      get :edit, params: {id: transaction.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Transaction" do
        sign_in user
        expect {
          post :create, params: {transaction: valid_attributes, wallet_id: wallet.id}, session: valid_session
        }.to change(Transaction, :count).by(1)
      end

      it "redirects to the created transaction" do
        sign_in user
        post :create, params: {transaction: valid_attributes, wallet_id: wallet.id}, session: valid_session
        expect(response).to redirect_to(wallet_path(wallet.id))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        sign_in user
        post :create, params: {transaction: invalid_attributes, wallet_id: wallet.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "Check Amount in wallet" do
      it "Amount is not enogh" do
        attrs = {wallet_id: wallet.id, name: "Withdraw to Bitcoin", ticker: "BTC", address: "asjdfhjhf", amount: 4.00120987, flag: 0 }
        FactoryBot.create(:wallet_currency, wallet_id: wallet.id)
        sign_in user
        post :create, params: {transaction: attrs, wallet_id: wallet.id}, session: valid_session
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { flag: 1 }
      }

      it "fail with notmal user" do
        transaction = Transaction.create! valid_attributes
        sign_in user
        put :update, params: {id: transaction.to_param, transaction: new_attributes}, session: valid_session
        transaction.reload
        expect(response).not_to be_successful
      end

      it "updates the requested transaction" do
        transaction = Transaction.create! admin_attributes
        sign_in admin
        put :update, params: {id: transaction.to_param, transaction: new_attributes}, session: valid_session
        transaction.reload
        expect(transaction.flag).to eq "completed"
      end

      it "redirects to the transaction" do
        transaction = Transaction.create! admin_attributes
        sign_in admin
        put :update, params: {id: transaction.to_param, transaction: valid_attributes}, session: valid_session
        expect(response).to redirect_to(transaction)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        transaction = Transaction.create! admin_attributes
        sign_in admin
        put :update, params: {id: transaction.to_param, transaction: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  #describe "DELETE #destroy" do
    #it "destroys the requested transaction" do
      #transaction = Transaction.create! valid_attributes
      #expect {
        #delete :destroy, params: {id: transaction.to_param}, session: valid_session
      #}.to change(Transaction, :count).by(-1)
    #end

    #it "redirects to the transactions list" do
      #transaction = Transaction.create! valid_attributes
      #delete :destroy, params: {id: transaction.to_param}, session: valid_session
      #expect(response).to redirect_to(transactions_url)
    #end
  #end

end
