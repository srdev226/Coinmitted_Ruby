require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do

  describe "NEW " do

    before :each do
      #@user = FactoryBot.create(:user, role: 'admin')
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "respond successful" do
      expect(response).to be_successful
    end

    it "have params" do
      get :new, params: { }
      expect(response.code).to eq '200'
    end
  end

  describe "POST create" do
    let(:user_attributes) {
      { email: "hello@hello.com", password: "123456", password_confirmation: "123456" }
    }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "should be successful" do
      expect(response).to be_successful
    end

    it "should create user" do
      expect {
        post :create, params: { user: user_attributes }
      }.to change(User, :count).by(1)
    end

    it "should have user with affiliate role" do
      post :create, params: { user: user_attributes }, session: { :role => 'affiliate' }
      expect(User.last.role).to eq "affiliate"
    end

    it "should have user with investor role" do
      post :create, params: { user: user_attributes }, session: { :role => 'investor' }
      expect(User.last.role).to eq "investor"
    end

    it "shuld redirect to right path after sign up" do
      post :create, params: { user: user_attributes }, session: { :role => 'investor' }
      expect(response).to redirect_to start_wizard_investment_path
    end

    it "should redirec to root path after sign up" do
      post :create, params: { user: user_attributes }, session: { :role => 'affiliate' }
      expect(response).to redirect_to root_path
    end

    it "should genereate user's profile" do
      expect {
        post :create, params: { user: user_attributes }, session: { :role => 'investor' }
      }.to change(Profile, :count).by(1)
    end

    it "should generate user's wallet" do
      expect {
        post :create, params: { user: user_attributes }, session: { :role => 'investor' }
      }.to change(Wallet, :count).by(1)
    end
  end
end
