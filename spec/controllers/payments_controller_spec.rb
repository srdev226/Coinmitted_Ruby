require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do

  describe "GET redirect" do
    it "should redirect to login" do
      get :index
      expect(response.code).to eq "302"
    end
  end

  describe "GET" do

    let(:payment) { Payment.create(investment_id: create(:investment).id) }

    login_user

    it "should return code 200" do
      get :index
      expect(response.code).to eq "200"
    end

    it "should return code for show" do
      get :show, params: { id: payment.id }
      expect(response.code).to eq "200"
    end
  end


end
