require 'rails_helper'

RSpec.describe "Payments", type: :request do

  before :each do
    FactoryBot.create(:investment)
  end

  describe "GET /payments_all" do
    it "payments path" do
      #get payments_all_path
      #expect(response).to have_http_status(200)
    end
  end
end
