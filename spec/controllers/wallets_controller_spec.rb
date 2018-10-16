require 'rails_helper'

RSpec.describe WalletsController, type: :controller do

  let(:user) { create :user }
  let(:wallet) { create :wallet, user_id: user.id }
  let(:profile) { create :profile, user_id: user.id }

  describe "GET #show" do
    it "returns http success" do
      sign_in user
      get :show, params: {id: wallet.id }
      expect(response).to have_http_status(:success)
    end
  end

end
