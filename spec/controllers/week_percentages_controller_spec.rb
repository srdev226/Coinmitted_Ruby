require 'rails_helper'

RSpec.describe WeekPercentagesController, type: :controller do

  let(:valid_attributes) {
    {first_date: Date.parse("2018-07-09"), date: Date.parse("2018-07-15"), last_date: Date.parse("2018-07-09"), percentage: 10}
  }

  let(:invalid_attributes) {
    {first_date: "dkfj", last_date: "kdjf", date: "ksjf", percentage: "f"}
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    login_user
    it "returns a success response" do
      week_percentage = WeekPercentage.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    login_user
    it "returns a success response" do
      week_percentage = WeekPercentage.create! valid_attributes
      get :show, params: {id: week_percentage.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    login_user
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    login_user
    it "returns a success response" do
      week_percentage = WeekPercentage.create! valid_attributes
      get :edit, params: {id: week_percentage.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    login_user
    context "with valid params" do
      it "creates a new WeekPercentage" do
        expect {
          post :create, params: {week_percentage: valid_attributes}, session: valid_session
        }.to change(WeekPercentage, :count).by(1)
      end

      it "redirects to the created week_percentage" do
        post :create, params: {week_percentage: valid_attributes}, session: valid_session
        expect(response).to redirect_to(WeekPercentage.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {week_percentage: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    login_user
    context "with valid params" do
      let(:new_attributes) {
        { first_date: Date.parse("2018-07-10"), last_date: Date.parse("2018-07-15"), date: Date.parse("2018-07-10"), percentage: 4}
      }

      it "updates the requested week_percentage" do
        week_percentage = WeekPercentage.create! valid_attributes
        put :update, params: {id: week_percentage.to_param, week_percentage: new_attributes}, session: valid_session
        week_percentage.reload
        expect(week_percentage.first_date).to eq Date.parse("2018-07-10")
      end

      it "redirects to the week_percentage" do
        week_percentage = WeekPercentage.create! valid_attributes
        put :update, params: {id: week_percentage.to_param, week_percentage: valid_attributes}, session: valid_session
        expect(response).to redirect_to(week_percentage)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        week_percentage = WeekPercentage.create! valid_attributes
        put :update, params: {id: week_percentage.to_param, week_percentage: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    it "destroys the requested week_percentage" do
      week_percentage = WeekPercentage.create! valid_attributes
      expect {
        delete :destroy, params: {id: week_percentage.to_param}, session: valid_session
      }.to change(WeekPercentage, :count).by(-1)
    end

    it "redirects to the week_percentages list" do
      week_percentage = WeekPercentage.create! valid_attributes
      delete :destroy, params: {id: week_percentage.to_param}, session: valid_session
      expect(response).to redirect_to(week_percentages_url)
    end
  end

end
