require 'rails_helper'

RSpec.describe "campaigns/new", type: :view do
  before(:each) do
    assign(:campaign, Campaign.new(
      :name => "MyString",
      :affiliates_count => 1,
      :earnings => "9.99",
      :url => "MyString"
    ))
  end

  it "renders new campaign form" do
    render

    assert_select "form[action=?][method=?]", campaigns_path, "post" do

      assert_select "input[name=?]", "campaign[name]"

      assert_select "input[name=?]", "campaign[affiliates_count]"

      assert_select "input[name=?]", "campaign[earnings]"

      assert_select "input[name=?]", "campaign[url]"
    end
  end
end
