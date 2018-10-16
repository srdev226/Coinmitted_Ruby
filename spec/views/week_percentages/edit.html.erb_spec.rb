require 'rails_helper'

RSpec.describe "week_percentages/edit", type: :view do
  before(:each) do
    @week_percentage = assign(:week_percentage, WeekPercentage.create!(
      :percentage => 4.5,
      date: Date.parse("2018-07-10")
    ))
  end

  #it "renders the edit week_percentage form" do
    #render

      #assert_select "form[action=?][method=?]", week_percentage_path(@week_percentage), "post" do

      #assert_select "input[name=?]", "week_percentage[percentage]"
    #end
  #end
end
