class PayoutGenerator

  attr_reader :attributes, :payout_frequency, :user_id, :timeframe

  def initialize(attributes)
    @attributes = attributes
    @payout_frequency = attributes.payout_frequency.title
    @user_id = attributes.user_id
    @timeframe = attributes.timeframe
  end

  def generate_weekly_payouts

    start_calculation_from = attributes.open_date #Date.today
    finish_calculation_to = attributes.end_date #Date.today.months_since(@timeframe)

    # Clesest Week Monday
    @pay_date = start_calculation_from.beginning_of_week

    while @pay_date <= finish_calculation_to.end_of_week do
      @pay_date = @pay_date.next_week
      set_payout(@pay_date)
    end

  end

  def generate_twice_payouts

    start_calculation_from = attributes.open_date #Date.today
    finish_calculation_to = attributes.end_date #Date.today.months_since(@timeframe)

    twice_arr = twice_a_month_schedule(start_calculation_from,finish_calculation_to)
    twice_arr.each do |date|
      set_payout(date)
    end

  end

  def generate_monthly_payouts

    start_calculation_from = attributes.open_date #Date.today
    finish_calculation_to = attributes.end_date #Date.today.months_since(@timeframe)
    @pay_date = start_calculation_from.at_beginning_of_month

    timeframe.times do |date|
      @pay_date = @pay_date.next_month
      set_payout(@pay_date)
    end

  end

  def generate_end_of_period_payouts
    start_calculation_from = attributes.open_date #Date.today
    finish_calculation_to = attributes.end_date #Date.today.months_since(@timeframe)
    set_payout(finish_calculation_to)
  end

  private

  def twice_a_month_schedule(start_date, end_date)
    arr = []
    (Date.parse(start_date.strftime("%Y-%m-%d"))..Date.parse(end_date.strftime("%Y-%m-%d"))).each do |date|
      if date.day.in? [1,15]
        arr << date
      end
    end
    if end_date.day < 15
      arr << Date.new(end_date.year, end_date.month, 15)
    elsif end_date.day > 15 && end_date < end_date.end_of_month + 1.day
      arr << Date.new(end_date.year, end_date.next_month.month, end_date.at_beginning_of_month.day)
    end
    arr
  end

  def set_payout(date)
    Payout.create(
      user_id: user_id,
      status: 0,
      pay_date: date,
      amount: 0,
      investment_id: attributes.id
    )
    #Rails.logger.tagged("Payout") do
      #Rails.logger.debug "PAYOUT generated #{Payout.last.inspect}"
    #end
  end
end
