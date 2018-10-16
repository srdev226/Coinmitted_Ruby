require 'rails_helper'

RSpec.describe "number_verifications/index", type: :view do
  before(:each) do
    assign(:number_verifications, [
      NumberVerification.create!(),
      NumberVerification.create!()
    ])
  end

  it "renders a list of number_verifications" do
    render
  end
end
