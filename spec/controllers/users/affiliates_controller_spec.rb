require 'rails_helper'

RSpec.describe Users::AffiliatesController, type: :controller do

  before :each do
    @user = FactoryBot.create(:user)
  end

  describe "GET index" do
    it "renders successfull" do
      sign_in @user
      get :index, params: {}
      expect(response).to be_successful
    end
  end
end
