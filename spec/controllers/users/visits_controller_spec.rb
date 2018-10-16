require 'rails_helper'

RSpec.describe Users::VisitsController, type: :controller do

  describe "GET index" do
    it "return success" do
      get :index, params: {}
      expect(response).to be_successful
    end

    it "render template" do
      get :index, params: {}
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    let(:user) { create(:user) }
    it "return with success" do
      visit = Ahoy::Visit.create(user_id: user.id)
      get :show, params: {id: visit.id}
      expect(response).to be_successful
    end
    it "render template" do
      visit = Ahoy::Visit.create(user_id: user.id)
      get :show, params: {id: visit.id}
      expect(response).to render_template :show
    end
  end
end
