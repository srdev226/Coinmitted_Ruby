require 'rails_helper'

RSpec.describe "number_verifications/new", type: :view do
  before(:each) do
    assign(:number_verification, NumberVerification.new())
  end

  it "renders new number_verification form" do
    render

    assert_select "form[action=?][method=?]", number_verifications_path, "post" do
    end
  end
end
