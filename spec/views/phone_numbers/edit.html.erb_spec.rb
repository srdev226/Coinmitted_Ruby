require 'rails_helper'

RSpec.describe "phone_numbers/edit", type: :view do
  before(:each) do
    @phone_number = assign(:phone_number, PhoneNumber.create!())
  end

  it "renders the edit phone_number form" do
    render

    assert_select "form[action=?][method=?]", phone_number_path(@phone_number), "post" do
    end
  end
end
