require 'rails_helper'

RSpec.describe NumberVerificationsController, type: :controller do

  let(:user) { create(:user) }
  let(:profile) { create(:profile, user_id: user.id ) }
  let(:phone_number) { create(:phone_number,
                              profile_id: profile.id) }

  let(:valid_attributes) {
    { number: "988373783", profile_id: profile.id }
  }

  let(:invalid_attributes) {
    { number: nil, profile_id: profile.id }
  }

  let(:valid_session) { {} }

  before :each do
    stub_request(:get, "https://free.currencyconverterapi.com/api/v6/convert?compact=y&q=USD_USD").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: "", headers: {})
  end

  describe "GET #new" do
    it "returns a success response" do
      sign_in user
      get :new, params: {id: phone_number.id}
      expect(response).to be_success
    end
  end


  describe "POST #create" do
    context "with valid params" do
      it "creates a new NumberVerification" do
        #sign_in user
        #expect {
          #post :create, params: {number_verification: valid_attributes}
        #}.to change(NumberVerification, :count).by(1)
      end

      it "redirects to the created number_verification" do
        #post :create, params: {number_verification: valid_attributes}, session: valid_session
        #expect(response).to redirect_to(NumberVerification.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        #post :create, params: {number_verification: invalid_attributes}, session: valid_session
        #expect(response).to be_success
      end
    end
  end

end
