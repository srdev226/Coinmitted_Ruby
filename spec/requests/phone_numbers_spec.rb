require 'rails_helper'

RSpec.describe "PhoneNumbers", type: :request do
  describe "GET /phone_numbers" do
    it "works! (now write some real specs)" do
      get phone_numbers_path
      expect(response).to have_http_status(200)
    end
  end
end
