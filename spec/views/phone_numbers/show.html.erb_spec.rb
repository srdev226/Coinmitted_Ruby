require 'rails_helper'

RSpec.describe "phone_numbers/show", type: :view do
  before(:each) do
    @phone_number = assign(:phone_number, PhoneNumber.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
