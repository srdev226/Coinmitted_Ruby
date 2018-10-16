require 'rails_helper'

RSpec.describe "number_verifications/show", type: :view do
  before(:each) do
    @number_verification = assign(:number_verification, NumberVerification.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
