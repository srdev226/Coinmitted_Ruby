require 'rails_helper'

RSpec.describe "campaigns/index", type: :view do
  before(:each) do
    assign(:campaigns, [
      Campaign.create!(
        :name => "Name",
        :affiliates_count => 2,
        :earnings => "9.99",
        :url => "Url"
      ),
      Campaign.create!(
        :name => "Name",
        :affiliates_count => 2,
        :earnings => "9.99",
        :url => "Url"
      )
    ])
  end

  it "renders a list of campaigns" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
