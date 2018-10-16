class DashboardsController < ApplicationController
  before_action :authenticate_user!

  # GET /investments
  # GET /investments.json
  def index

    @investments = Investment.where(user_id: current_user.id)
    @investment_plans = @investments.group_by { |i| i.investment_plan_id }
    #@week_percentages = WeekPercentage.order(first_date: :asc).where("last_date < ?", Date.today)
    @week_percentages = WeekPercentage.order(first_date: :asc).where("last_date > ?", Date.today - 6.month)
    @users = User.all

    #for affiliates dashboard
    @affiliate_levels = AffiliateLevel.all
    @affiliates_users = current_user.affiliates_with_investments

    # TODO Refactor
    case current_user.role
    #when "admin"
    #  render "dashboards/admin"
    when "user" # investor
      render params[:d] ? "dashboards/#{params[:d]}" : "dashboards/investor"
    when "investor"
      render params[:d] ? "dashboards/#{params[:d]}" : "dashboards/investor"
    when "affiliate"
      render params[:d] ? "dashboards/#{params[:d]}" : "dashboards/affiliate"
    #else
      # else, investor
      #render "dashboards/user"
    end
  end

end
