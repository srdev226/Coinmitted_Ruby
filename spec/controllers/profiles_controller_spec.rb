require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do

  login_user

  let(:user_profile) { FactoryBot.create(:profile,
                                         user_id: FactoryBot.create(:user).id) }

  let(:valid_attributes) {
    { name: "John Dow", bio: "here is bio", user_id: FactoryBot.create(:user).id }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProfilesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      #profile = user_profile.create! valid_attributes
      #get :index, params: {}, session: valid_session
      #expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      # TODO not implemented #SHOW
      #profile = Profile.create! valid_attributes
      #get :show, params: {id: user_profile.to_param}, session: valid_session
      #expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      # TODO not implemented #EDIT
      #get :new, params: {}, session: valid_session
      #expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      #sign_in
      stub_request(:get, "https://free.currencyconverterapi.com/api/v6/convert?compact=y&q=USD_USD").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: "", headers: {})

      get :edit
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Profile" do
        expect {
          post :create, params: {profile: valid_attributes}, session: valid_session
        }.to change(Profile, :count).by(1)
      end

      it "redirects to the created profile" do
        post :create, params: {profile: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Profile.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {profile: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "New Name" }
      }

      it "updates the requested profile" do
        #profile = Profile.create! valid_attributes
        put :update, params: {id: user_profile.to_param, profile: new_attributes}, session: valid_session
        user_profile.reload
        expect(user_profile.name).to eq "New Name"
      end

      it "redirects to the profile" do
        #profile = Profile.create! valid_attributes
        put :update, params: {id: user_profile.to_param, profile: valid_attributes}, session: valid_session
        expect(response).to redirect_to(user_profile)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        #profile = Profile.create! valid_attributes
        put :update, params: {id: user_profile.to_param, profile: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested profile" do
      user_profile # first create profile
      expect {
        delete :destroy, params: {id: user_profile.to_param}, session: valid_session
      }.to change(Profile, :count).by(-1)
    end

    it "redirects to the profiles list" do
      #profile = Profile.create! valid_attributes
      delete :destroy, params: {id: user_profile.to_param}, session: valid_session
      expect(response).to redirect_to(profiles_url)
    end
  end

end
