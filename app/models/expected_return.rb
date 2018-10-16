class ExpectedReturn

  attr_reader :wizard_investment, :frequency, :user

  PF = { :weekly => 4, :twice => 2, :monthly => 1, :end_of_period => 0 }.freeze
  END_OF_PERIOD = 5
  RETURN_REP_MONTH = 25

  # TODO better to replace object with simple data in the future:
  # expected_amount, open_date, end_date, timeframe

  def initialize(wizard_investment, frequency, user)
    @wizard_investment = wizard_investment
    @frequency = frequency
    @user = user
    @invest_from_date = @wizard_investment["open_date"].to_date
    @invest_to_date = @wizard_investment["end_date"].to_date
    @timeframe = @wizard_investment["timeframe"]
  end

  def amount
    invested_amount = @wizard_investment["invested_amount"]
    result = invested_amount * total_percentage / 100

    if frequency == "end_of_period"
      invested_amount = invested_amount * 1.05
    end
    invested_amount + result
  end

  # Create weekly Payout
  def payout_weekly
    start_calculation_from = Date.today.months_ago(@timeframe)
    finish_calculation_to = Date.today

    first_week = prev_weeks.first
    last_week = prev_weeks.last

    @pay_date = Date.today.end_of_week + 1.day

    prev_weeks.each do |week|

      if week.last_date === first_week.last_date
        days = 0
        while start_calculation_from <= week.last_date do
          days += 1
          start_calculation_from = start_calculation_from + 1.day
        end
        percentage = (week.percentage.to_f / 7) * days

        amount = @wizard_investment["invested_amount"] * percentage / 100
        payout_create(@pay_date, amount)

        # first week
        @pay_date = @pay_date += 7.day

      elsif week.first_date === last_week.first_date

        days = 0
        while finish_calculation_to > last_week.first_date do
          days += 1
          finish_calculation_to = finish_calculation_to - 1.day
        end
        percentage = (week.percentage.to_f / 7) * days
        amount = @wizard_investment["invested_amount"] * percentage / 100
        payout_create(@pay_date, amount)
        # last week
        @pay_date = @pay_date += 7.day

      else

        amount = @wizard_investment["invested_amount"] * week.percentage.to_f / 100
        payout_create(@pay_date, amount)
        # between weeks
        @pay_date = @pay_date += 7.day

      end
    end
  end

  def payout_twice
    start_calculation_from = Date.today.months_ago(@timeframe)
    finish_calculation_to = Date.today

    first_week = prev_weeks.first
    last_week = prev_weeks.last

    @pay_date = Date.today.end_of_week + 8.day

    prev_weeks.each_slice(2) do |slice|

      @percentage = 0.0
      slice.each do |week|
        if week.last_date === first_week.last_date
          # first week
          days = 0
          while start_calculation_from <= slice.first.last_date do
            days += 1
            start_calculation_from = start_calculation_from + 1.day
          end
          @percentage += (week.percentage.to_f / 7) * days
        elsif week.first_date === last_week.first_date
          # last week
          days = 0
          while finish_calculation_to > last_week.first_date do
            days += 1
            finish_calculation_to = finish_calculation_to - 1.day
          end
          @percentage += (week.percentage.to_f / 7) * days
        else
          # between weeks
          @percentage += week.percentage.to_f
        end # slice.each
      end

      amount = @wizard_investment["invested_amount"] * @percentage / 100
      payout_create(@pay_date, amount)
      @pay_date = @pay_date + 14.day

    end # each_slice
  end

  def payout_monthly
    start_calculation_from = Date.today.months_ago(@timeframe)
    finish_calculation_to = Date.today

    first_week = prev_weeks.first
    last_week = prev_weeks.last
    @pay_date = Date.today.at_beginning_of_month.next_month

    prev_weeks.each_slice(4) do |month|
      @percentage = 0.0
      month.each do |week|

        if week.last_date === first_week.last_date
          days = 0
          while start_calculation_from <= month.first.last_date do
            days += 1
            start_calculation_from = start_calculation_from + 1.day
          end
          @percentage += (week.percentage.to_f / 7) * days
        elsif week.first_date === last_week.first_date
          days = 0
          while finish_calculation_to > last_week.first_date do
            days += 1
            finish_calculation_to = finish_calculation_to - 1.day
          end
          @percentage += (week.percentage.to_f / 7) * days
        else
          @percentage += week.percentage.to_f
        end

      end # month.each
      amount = @wizard_investment["invested_amount"] * @percentage / 100
      payout_create(@pay_date, amount)
      @pay_date = @pay_date.next_month
    end # weeks_slice to 4 weeks
  end

  def payout_end_of_period
    start_calculation_from = Date.today.months_ago(@timeframe)
    finish_calculation_to = Date.today

    first_week = prev_weeks.first
    last_week = prev_weeks.last
    @pay_date = last_week.last_date.end_of_week + 1.day
    @percentage = 0.0

    prev_weeks.each do |week|
      if week.last_date === first_week.last_date
        days = 0
        while start_calculation_from <= week.last_date do
          days += 1
          start_calculation_from = start_calculation_from + 1.day
        end
        @percentage += (week.percentage.to_f / 7) * days
      elsif week.first_date === last_week.first_date
        days = 0
        while finish_calculation_to > last_week.first_date do
          days += 1
          finish_calculation_to = finish_calculation_to - 1.day
        end
        @percentage += (week.percentage.to_f / 7) * days
      else
        @percentage += week.percentage.to_f
      end
    end
    @percentage += @percentage * END_OF_PERIOD / 100
    amount = @wizard_investment["invested_amount"] * @percentage.to_f / 100
    payout_create(@pay_date, amount)
  end

  def payout_create(date, amount)
    Payout.create(
      user_id: user.id,
      status: 0,
      pay_date: date,
      amount: amount,
      investment_id: @wizard_investment["id"]
    )
  end

  def total_earnings
    invested_amount = @wizard_investment["invested_amount"]
    result = invested_amount * total_percentage / 100
    if frequency == "end_of_period"
      result += invested_amount * 0.05
    end
    result
  end

  # Expected Earnings is the calculation of an investment return, we will do the calculation based on 25% per month:
  # This means if I invest $1000:
  # 1 Month: $1000 x25%= $1250
  # 2 Months $1000 x 50% = $1500
  # 3 Months $1000 x 75% = $1750
  # 4 Months $1000 x 100% = $2000
  def return_25
    multiplier = @wizard_investment["timeframe"] * RETURN_REP_MONTH
    amount = (multiplier * @wizard_investment["invested_amount"] / 100)
    result = amount + @wizard_investment["invested_amount"]
    result
  end

  def total_percentage
    result = 0.0
    start_calculation_from = Date.today.months_ago(@timeframe)
    finish_calculation_to = Date.today
    first_week = prev_weeks.first
    last_week = prev_weeks.last

    prev_weeks.each do |week|

      if week.last_date === first_week.last_date

        days = 0
        while start_calculation_from <= week.last_date do
          days += 1
          start_calculation_from = start_calculation_from + 1.day
        end
        percentage = (week.percentage.to_f / 7) * days
        result += percentage

      elsif week.first_date === last_week.first_date

        days = 0
        while finish_calculation_to > last_week.first_date do
          days += 1
          finish_calculation_to = finish_calculation_to - 1.day
        end
          percentage = (week.percentage.to_f / 7) * days
          result += percentage
      else
        result += week.percentage.to_f
      end
    end
    result
  end

  def payout_frequency
    frequency = PayoutFrequency.find(@wizard_investment["payout_frequency_id"].to_i)
    PF[frequency.name.to_sym]
  end

  def prev_weeks
    WeekPercentage.where(
      "last_date > ?", Date.today.months_ago(@timeframe)
    ).where(
      "first_date < ?", Date.today
    )
  end

  def months
    result = []
    start_date = @wizard_investment.open_date.beginning_of_month
    end_date = @wizard_investment.end_date.end_of_month
    while start_date <= end_date
      result << start_date.month
      start_date = start_date.next_month
    end
    return result
  end


end
