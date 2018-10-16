class PerformanceController < ApplicationController
  before_action :authenticate_user!

  def index
  	@months = [
  		"January",
  		"February",
  		"March",
  		"April",
  		"May",
  		"June",
  		"July",
  		"August",
  		"September",
  		"October",
  		"November",
  		"December",
  	]
  	@wp_order = WeekPercentage.order(first_date: :asc)
  	@weeks = @wp_order.count()
  	@st_year = @wp_order.first.first_date.year
  	@end_year = @wp_order.last.first_date.year
  	@st_mon = @wp_order.first.first_date.month
  	@total_weeks = @wp_order.all

  	@total_percentages = []
  	@total_return = 0;
  	@weekly_ddownlist_m = []
  	@weekly_ddownlist_y = []
    @weekly_shows = []
  	(1...@st_mon).each do |i|
  		@total_percentages[i-1] = ""
  	end

  	@year_total_ret = 0
  	@m_index = @wp_order.first.first_date.month
  	@total_percentages[@st_mon - 1] = 0
  	@ind = 0
    @weekly_shows[0] = []
    @s_ind= 0
  	(0...@weeks).each do |i|
  		if @m_index != @total_weeks[i].first_date.month
        @s_ind = 0
  			@ind = @ind + 1
  			@total_percentages[@st_mon + @ind - 1] = 0 
        @weekly_shows[@ind] = []
  			@m_index = @total_weeks[i].first_date.month
  			@total_percentages[@st_mon + @ind - 1] += @total_weeks[i].percentage
  			@total_return += @total_weeks[i].percentage

  		else			
  			@total_percentages[@st_mon + @ind - 1] += @total_weeks[i].percentage
  			@total_return += @total_weeks[i].percentage
		  end	
      @weekly_shows[@ind][@s_ind] = "#{@months[@total_weeks[i].first_date.month]} #{@total_weeks[i].first_date.day} - #{@months[@total_weeks[i].last_date.month]} #{@total_weeks[i].last_date.day}"
  		@weekly_ddownlist_m[@ind] = "#{@months[@m_index - 1]}"
  		@weekly_ddownlist_y[@ind] = " #{@total_weeks[i].first_date.year}"
      @s_ind = @s_ind + 1
  	end
    @week_percentages = @wp_order.where("last_date > ?", Date.today - 6.month)
    @investments = Investment.where(user_id: current_user.id)
  end
  def chartdata
    if params[:type] == 'weekly'
      retdata = WeekPercentage.order(first_date: :asc).all
      render json: {chartdata: retdata}
    else
      all_weeks = WeekPercentage.order(first_date: :asc)
      st_month = all_weeks.first.first_date.month
      st_year = all_weeks.first.first_date.year

      end_month = all_weeks.last.first_date.month
      end_year = all_weeks.last.first_date.year

      st_date = Time.new(st_year, st_month, 1).to_date
      end_date = Time.new(end_year, end_month, 1).to_date
      p end_date
      retdata = []
      while st_date <= end_date do
        percentage = all_weeks.where("first_date >= ?", st_date).where("first_date <= ?", st_date + 1.month).sum(:percentage)
        retdata.push({last_date: st_date + 15.day, percentage: percentage})
        st_date = st_date + 1.month
      end
      render json: {chartdata: retdata}
    end
  end
end
