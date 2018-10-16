class AdminController < ApplicationController

  def index
  end

  def week_percentages
    @week_percentages = WeekPercentage.all
  end
end
