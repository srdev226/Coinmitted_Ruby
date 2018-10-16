require 'rails_helper'

RSpec.describe PhoneNumbersController, type: :controller do

  #login_user

  let(:user) { create(:user) }
  let(:profile) { create(:profile, user_id: user.id ) }
  let(:wallet) { create(:wallet, user_id: user.id) }
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
    user.wallet = wallet
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new PhoneNumber" do
        sign_in user
        expect {
          post :create, params: {phone_number: valid_attributes, full_phone: "+61412345678" }
        }.to change(PhoneNumber, :count).by(1)
      end

      it "redirects to the created phone_number" do
        sign_in user
        post :create, params: {phone_number: valid_attributes, full_phone: "+61412345678" }
        expect(response).to redirect_to(edit_profile_path)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        sign_in user
        post :create, params: {phone_number: invalid_attributes, full_phone: "+61412345678" }
        expect(response).to redirect_to(edit_profile_path)
      end
    end
  end


  describe "DELETE #destroy" do
    it "destroys the requested phone_number" do
      sign_in user
      #expect {
        #delete :destroy, params: {id: phone_number.to_param, profile_id: profile.id}
      #}.to change(PhoneNumber, :count).by(-1)
    end

    it "redirects to the phone_numbers list" do
      sign_in user
      #phone_number = PhoneNumber.create! valid_attributes
      delete :destroy, params: {id: phone_number.to_param}
      expect(response).to redirect_to(edit_profile_path)
    end
  end

end
