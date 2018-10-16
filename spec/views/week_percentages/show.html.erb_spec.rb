require 'rails_helper'

RSpec.describe "week_percentages/show", type: :view do
  before(:each) do
    @week_percentage = assign(:week_percentage, WeekPercentage.create!(
      :percentage => 4,
      :date => Date.parse("2018-07-10"),
      :first_date => Date.parse("2018-07-10"),
      :last_date => Date.parse("2018-07-10"),
    ))
  end

  #it "renders attributes in <p>" do
    #render
    #expect(rendered).to match(/Percentage/)
  #end
end
