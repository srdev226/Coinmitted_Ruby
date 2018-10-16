class ExpectedReturnController < ApplicationController

  #before_action :authenticate_user!

  # app/controllers/concerns
  include Response

  def earning
    inv = Wizard::Investment::Amount.new(
      name: params[:investment][:name],
      investment_plan_id: params[:investment][:invested_plan_id].to_i,
      invested_amount: params[:investment][:invested_amount].to_f,
      open_date: params[:investment][:open_date].to_date,
      end_date: params[:investment][:end_date].to_date,
      user_id: params[:investment][:user_id].to_i,
      timeframe: params[:investment][:timeframe].to_i,
      payout_frequency_id: params[:investment][:payout_frequency_id].to_i
    )

    if inv.present?
      @expected = ExpectedReturn.new(
        inv.investment,
        inv.investment.payout_frequency.name,
        inv.user_id.to_i
      )
      @expected
    else
      return 0
    end

    json_response(@expected.total_earnings)
  end

  def per_month_25

    inv = Wizard::Investment::Amount.new(
      name: params[:investment][:name],
      investment_plan_id: params[:investment][:invested_plan_id].to_i,
      invested_amount: params[:investment][:invested_amount].to_f,
      open_date: params[:investment][:open_date].present? ? params[:investment][:open_date].to_date : Date.today,
      end_date: params[:investment][:end_date].present? ? params[:investment][:end_date].to_date : Date.today + params[:investment][:timeframe].to_i.month,
      user_id: params[:investment][:user_id].to_i ? params[:investment][:user_id].to_i : 1,
      timeframe: params[:investment][:timeframe].to_i,
      payout_frequency_id: 1
    )

    #result = ExpectedReturn.new(
     # new_inv.attributes,
    #  new_inv.payout_frequency.name,
     # current_user
    #)

    multiplier = inv.investment.timeframe * 25
    amount = (multiplier * inv.invested_amount / 100)
    result = amount + inv.invested_amount
    #binding.pry
    json_response(result)
  end

  def fiat_crypto_rate
    #binding.pry
  end

  private

  def inv_params
    params.require(:investment).permit(
      :investment_plan_id, :name, :invested_amount, :status, :open_date, :end_date,
      :user_id, :timeframe, :payout_frequency_id, :payment_method_id, :expected_return
    )
  end

end
