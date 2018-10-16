require 'rails_helper'

RSpec.describe "phone_numbers/new", type: :view do
  before(:each) do
    assign(:phone_number, PhoneNumber.new())
  end

  it "renders new phone_number form" do
    render

    assert_select "form[action=?][method=?]", phone_numbers_path, "post" do
    end
  end
end
