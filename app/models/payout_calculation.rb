class PayoutCalculation

  attr_reader :payout

  def initialize(payout)
    @payout = payout
  end

  def calculate
    case frequency
    when "weekly"
      weekly_payouts
    when "twice"
      twice_payouts
    when "monthly"
      monthly_payouts
    when "end_of_period"
      end_of_period_payouts
    end
  end

  def frequency
    payout.investment.payout_frequency.name
  end

  def weekly_payouts
    week_percentage = WeekPercentage.where("last_date < ?", payout.pay_date).last
    if week_percentage.first_date < payout.investment.open_date
      num_days = (week_percentage.last_date.to_date - payout.investment.open_date.to_date).to_i
      percentage = (week_percentage.percentage.to_f / 7) * num_days
    elsif week_percentage.last_date > payout.investment.end_date
      num_days = (payout.investment.end_date.to_date - week_percentage.first_date.to_date).to_i
      num_days = num_days + 1 # add one day to include Monday in to calculation
      percentage = (week_percentage.percentage.to_f / 7) * num_days
    else
      percentage = week_percentage.percentage.to_f unless payout.investment.end_date < week_percentage.first_date
    end
    weekly_payout = payout.investment.invested_amount * percentage.round(2) / 100
    payout.update_attributes(amount: weekly_payout, status: 1)

  end

  def twice_payouts
    if payout.pay_date.day == 01
      percentage_day = payout.pay_date.prev_month + 14.day
    elsif payout.pay_date.day == 15
      percentage_day = payout.pay_date.at_beginning_of_month
    end
    week_percentages = WeekPercentage.where("last_date > ?", percentage_day).where("last_date < ?", payout.pay_date)
    percentage = set_week_percentages(week_percentages)
    twice_payout = payout.investment.invested_amount * percentage.round(2) / 100
    payout.update_attributes(amount: twice_payout, status: 1)
  end

  def monthly_payouts
    week_percentages = WeekPercentage.where("last_date > ?", payout.pay_date.prev_month).where("last_date < ?", payout.pay_date)
    percentage = set_week_percentages(week_percentages)
    monthly_payout = payout.investment.invested_amount * percentage.round(2) / 100
    payout.update_attributes(amount: monthly_payout, status: 1)

  end

  def end_of_period_payouts
    week_percentages = WeekPercentage.where("last_date > ?", payout.investment.open_date).where("last_date < ?", payout.pay_date)
    percentage = set_week_percentages(week_percentages)
    percentage += 5.0
    end_of_period_payout = payout.investment.invested_amount * percentage.round(2) / 100
    payout.update_attributes(amount: end_of_period_payout, status: 1)
  end

  private

  def set_week_percentages(week_percentages)
    percentage = 0.0
    week_percentages.each do |week|
      range = week.first_date..week.last_date
      if range === payout.investment.open_date
        num_days = (week.last_date.to_date - payout.investment.open_date.to_date ).to_i
        percentage += (week.percentage.to_f / 7) * num_days
      elsif range === payout.investment.end_date
        num_days = (payout.investment.end_date.to_date - week.first_date.to_date).to_i
        num_days = num_days + 1 # add one day to include Monday in to calculation
        percentage += (week.percentage.to_f / 7) * num_days
      elsif payout.investment.end_date > week.last_date && payout.investment.open_date < week.first_date
        percentage += week.percentage.to_f
      end
    end
    percentage
  end
end
