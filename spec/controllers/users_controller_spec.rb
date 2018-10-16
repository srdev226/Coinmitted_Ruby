require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET index without user" do
    it "should redirect to sign in" do
      get :index, params: {}
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "GET #index" do
    before :each do
      @user = FactoryBot.create(:user, role: 'user')
      @admin = FactoryBot.create(:user, role: 'admin')
    end

    it "returns a redirect to sign in response" do
      sign_in @user
      get :index, params: {}
      expect(response).to redirect_to root_path
    end

    it "return a redirect to root" do
      sign_in @admin
      get :index, params: {}
      expect(response).to be_successful
    end
  end


end
