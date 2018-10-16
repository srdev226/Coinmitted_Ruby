require 'rails_helper'

RSpec.describe "number_verifications/edit", type: :view do
  before(:each) do
    @number_verification = assign(:number_verification, NumberVerification.create!())
  end

  it "renders the edit number_verification form" do
    render

    assert_select "form[action=?][method=?]", number_verification_path(@number_verification), "post" do
    end
  end
end
