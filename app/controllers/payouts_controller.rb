class PayoutsController < ApplicationController
  before_action :authenticate_user!

  def index
    payouts = Payout.order(pay_date: :desc)
    payouts = payouts.where(user_id: current_user.id) unless current_user.admin?
    payouts = payouts.where(investment_id: params[:investment_id]) if params[:investment_id].present?
    @payouts = payouts
  end

  def show
    @payout = Payout.find(params[:id])
  end

end
