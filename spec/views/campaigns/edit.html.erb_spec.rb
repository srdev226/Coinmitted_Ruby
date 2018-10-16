require 'rails_helper'

RSpec.describe "campaigns/edit", type: :view do
  before(:each) do
    @campaign = assign(:campaign, Campaign.create!(
      :name => "MyString",
      :affiliates_count => 1,
      :earnings => "9.99",
      :url => "MyString"
    ))
  end

  it "renders the edit campaign form" do
    render

    assert_select "form[action=?][method=?]", campaign_path(@campaign), "post" do

      assert_select "input[name=?]", "campaign[name]"

      assert_select "input[name=?]", "campaign[affiliates_count]"

      assert_select "input[name=?]", "campaign[earnings]"

      assert_select "input[name=?]", "campaign[url]"
    end
  end
end
