class InvestmentDetailSerializer < ActiveModel::Serializer
  include DashboardsHelper
  attributes :id, :name, :invested, :earnings, :currency, :cur_sign, :plan, :investment_plan_id, :status, :status_text, :open_date, :timeframe, :timeframe_int, :payout_frequency, :payout_frequency_id, :end_date, :loss_protection, :payment_method_id

  def status_text
    case object.status
    when 'active'
      'Active'
    when 'draft'
      'Saved'
    when 'ended'
      'Fully paid'
    when 'payment'
      'Waiting for payment'
    end
  end

  def invested
    unless object.currency.nil? && object.invested_amount.nil?
      object.invested_amount
    else
      0.0
    end
  end

  def currency
    object.currency.upcase unless object.currency.nil?
  end

  def cur_sign
    Currency::CUR_SIGNS[object.currency.upcase] unless object.currency.nil?
  end

  def earnings
    unless object.currency.nil?
      object.earned ? object.earned : 0
    else
      0.0
    end
  end

  def plan
    "#{object.investment_plan.title} (#{object.investment_plan.subtitle})"
  end

  def open_date
    object.open_date.strftime('%b %e,%Y')
  end

  def timeframe
    "#{object.timeframe} Months"
  end

  def timeframe_int
    object.timeframe
  end

  def payout_frequency
    object.payout_frequency.title
  end

  def end_date
    object.end_date.strftime('%b %e,%Y')
  end

  def loss_protection
    'Yes'
  end

  def payout_frequency_id
    object.payout_frequency.id
  end

  def payment_method_id
    object.payment_method.id
  end

  def investment_plan_id
    object.investment_plan.id
  end
end
