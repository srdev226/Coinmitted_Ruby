require 'rails_helper'

RSpec.describe "week_percentages/index", type: :view do
  before(:each) do
    assign(:week_percentages, [
      WeekPercentage.create!(
        :percentage => 10,
        :date => Date.parse("2018-07-11"),
        :first_date => Date.parse("2018-07-05"),
        :last_date => Date.parse("2018-07-15"),
      ),
      WeekPercentage.create!(
        :percentage => 4.5,
        :date => Date.parse("2018-07-10"),
        :first_date => Date.parse("2018-07-04"),
        :last_date => Date.parse("2018-07-14"),
      )
    ])
  end

  it "renders a list of week_percentages" do
    #render
    #assert_select "tr>td", :text => "First date".to_s, :count => 2
  end
end
