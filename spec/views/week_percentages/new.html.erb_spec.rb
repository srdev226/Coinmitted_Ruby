require 'rails_helper'

RSpec.describe "week_percentages/new", type: :view do
  before(:each) do
    assign(:week_percentage, WeekPercentage.new(
      :percentage => "MyString"
    ))
  end

  #it "renders new week_percentage form" do
    #render

    #assert_select "form[action=?][method=?]", week_percentages_path, "post" do

      #assert_select "input[name=?]", "week_percentage[percentage]"
    #end
  #end
end
