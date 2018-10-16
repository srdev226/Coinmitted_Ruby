require 'rails_helper'

RSpec.describe "phone_numbers/index", type: :view do
  before(:each) do
    assign(:phone_numbers, [
      PhoneNumber.create!(),
      PhoneNumber.create!()
    ])
  end

  it "renders a list of phone_numbers" do
    render
  end
end
