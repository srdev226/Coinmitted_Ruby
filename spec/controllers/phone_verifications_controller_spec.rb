require 'rails_helper'

RSpec.describe PhoneVerificationsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #challenge" do
    it "returns http success" do
      get :challenge
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #verify" do
    it "returns http success" do
      get :verify
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #success" do
    it "returns http success" do
      get :success
      expect(response).to have_http_status(:success)
    end
  end

end
