require 'rails_helper'

RSpec.describe Users::CampaignsController, type: :controller do

  describe "GET index" do
    it "render successfully" do
      get :index, params: {}
      expect(response).to be_successful
    end
    it "renders template" do
      get :index, params: {}
      expect(response).to render_template :index
    end
    it "have users_campaigns variable" do
      get :index, params: {}
      expect(assigns(:users_campaigns)).to match_array @users_campaigns
    end
  end

  describe "GET new" do
    render_views
    it "successful" do
      get :new, params: {}
      expect(response).to be_successful
    end
    it "renders template new" do
      get :new, params: {}
      expect(response).to render_template :new
    end
    it "render" do
      get :new, params: {}
      expect(response.body).to match "New Campaign"
    end
    it "assigns new campaign" do
      get :new, params: {}
      expect(response).to render_template(partial: '_form')
    end
  end

  describe "GET show" do
    let(:user) { create(:user) }
    render_views
    it "respond successful" do
      campaign = Users::Campaign.create(name: "test", user_id: user.id)
      get :show, params: {id: campaign.id}
      expect(response).to be_successful
    end
    it "render template show" do
      campaign = Users::Campaign.create(name: "test", user_id: user.id)
      get :show, params: { id: campaign.id }
      expect(response).to render_template :show
    end
  end

  describe "POST create" do
    let(:user) { create(:user) }
    let(:attributes) {
      {name: "test", user_id: user.id}
    }
    it "creates campaign" do
      sign_in user
      expect {
        post :create, params: { users_campaign: attributes }
      }.to change(Users::Campaign, :count).by(1)
    end
  end

  describe "GET edit" do
    let(:user) { create :user }
    before :each do
      @campaign = Users::Campaign.create(name: "test", user_id: user.id)
    end
    render_views

    it "render successful" do
      get :edit, params: {id: @campaign.id}
      expect(response).to be_successful
    end

    it "render template edit" do
      get :edit, params: { id: @campaign.id }
      expect(response).to render_template :edit
    end

    it "match word in rendered news" do
      get :edit, params: { id: @campaign.id }
      expect(response.body).to match /Editing Users/
    end

    it "renders partial form" do
      get :edit, params: { id: @campaign.id }
      expect(response).to render_template partial: '_form'
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create :user }

    it "destroys the requested campaign" do
      sign_in user
      campaign = Users::Campaign.create(name: "test", user_id: user.id)
      expect {
        delete :destroy, params: { id: campaign.to_param }
      }.to change(Users::Campaign, :count).by(-1)
    end

    it "redirects to the phone_numbers list" do
      sign_in user
      campaign = Users::Campaign.create(name: "test", user_id: user.id)
      delete :destroy, params: {id: campaign.to_param}
      expect(response).to redirect_to(users_campaigns_path)
    end
  end

end
