module DashboardsHelper

  def chart_data(data)
    weeks = {}
    weeks = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

    data.each_with_index do |week, index|
      weeks[week.last_date.strftime("%B").downcase.to_sym][week.last_date] = week.percentage
    end
    weeks
  end

  def datasets(data)
    w0 = [], w1 = [], w2 = [], w3 = [], w4 = [], w5 = []

    chart_data(data).keys.each_with_index do |month, index|
      chart_data(data)[month].each do |key,val|
        w1 << val.to_i if key.week_split[0].include?(key.day)
        w2 << val.to_i if key.week_split[1].include?(key.day)
        w3 << val.to_i if key.week_split[2].include?(key.day)
        w4 << val.to_i if key.week_split[3].include?(key.day)
        w5 << val.to_i if key.week_split[4].include?(key.day)
      end
    end

    one = eval("{ label: 'W1', backgroundColor: 'rgba(54,162,235,0.2)', data: #{w1} }")
    two = eval("{ label: 'W2', backgroundColor: 'rgba(54,162,235,0.4)', data: #{w2} }")
    three = eval("{ label: 'W3', backgroundColor: 'rgba(54,162,235,0.6)', data: #{w3} }")
    four = eval("{ label: 'W4', backgroundColor: 'rgba(54,162,235,0.8)', data: #{w4} }")
    five = eval("{ label: 'W5', backgroundColor: 'rgba(54,162,235,0.9)', data: #{w5} }")
    [one,two,three,four,five]
  end

  # collection
  def average_weekly(wp)
    result = wp.average(:percentage)
    number_to_percentage(result, precision: 2)
  end

  # collection
  def last_week(wp)
    number_to_percentage(wp.last.percentage, precision: 2)
  end

  # collection
  def last_month(wp)
    last = graph_month(wp)
    number_to_percentage(last.last, precision: 2)
  end

  # collection
  def best_month(wp)
    max = graph_month(wp).max
    number_to_percentage(max, precision: 2)
  end

  # collection
  def worst_month(wp)
    min = graph_month(wp).min
    number_to_percentage(min, precision: 2)
  end

  # collection
  def graph_month(wp)
    result = 0.0
    arr = []
    months = wp.group_by { |m| m.first_date.beginning_of_month }
    months.each_with_index do |item,i|
      tmp = 0
      item[1].each { |w| tmp +=  w.percentage.to_f }
      arr << tmp / item[1].count
    end
    arr
  end

  # model = Investment.first
  def profit(model)
    number = model.investment_earning.to_f * 100 / model.invested_amount.to_f
    "#{number > 0 ? '+' : ''}#{number_to_percentage(number)}"
  end

  # Object @investments = Investment.all
  def next_payout(investments)
    payouts = []
    investments.each do |inv|
      inv.payouts.each do |item|
        if item.pay_date >= Date.today
          payouts << item.pay_date
        end
      end
    end
    payouts.sort_by { |date| (date.to_time - Date.today.to_time).abs }.first
  end

  # object = Investement.all
  def amounts_in_cur_currency(object, type = "invested")
    result = 0.0
    currency = @currency.present? ? @currency : "USD"
    object.each do |item|
      if item.currency.present?
        if item.currency.upcase == currency.upcase
          if type == "invested"
            result += item.invested_amount.to_f
          else
            result += item.earned.to_f
          end
        else
          #converter = Rate.where(from: item.currency.upcase, to: currency).first
          #rate = converter.rate.to_f
          converter = Currency::Converter.new(item.currency,currency)
          rate = converter.get_rate.to_f
          if type == "invested"
            result += item.invested_amount.to_f * rate
          else
            result += item.earned.to_f * rate.to_f
          end
        end
      end # if item.currency
    end
    result
  end

  # admin dashboard
  def total_users_invested(arr, invested = true)
    result = []
    arr.each do |item|
      if item == invested
        result << 1
      end
    end
    result.inject(:+)
  end

  # admin dashboards
  def percentage(full, find)
    #result = full.to_f / find.to_f * 100
    result = find.to_f * 100 / full.to_f

    number_to_percentage(result)
  end

  # admin dashboard
  # user's balance stored in USD
  def total_users_balance(users,currency)
    balance = users.map{ |u| u.profile.balance.present? ?  u.profile.balance : 0.0 }.inject(:+)
    rate = Currency::Converter.new(currency.upcase,'USD').get_rate
    balance = balance * rate
    number_to_currency(balance, unit: "")
  end

  # admin dashboard
  def total_users_pending_withdrawal(users,currency)
    final_amount = 0.0
    users.each do |user|
      if user.wallet.nil? || user.wallet.transactions.nil?
        final_amount += 0
      else
        user.wallet.transactions.each do |tx|
          if tx.flag == "pending"
            final_amount += CryptoConverter.new(currency,tx.ticker, tx.amount.to_f).to_fiat
          end
        end
      end
    end
    final_amount
  end

  # admin dashboard
  def total_users_withdrawal(users, currency)
    final_amount = 0.0
    users.each do |user|
      if user.wallet.nil? || user.wallet.transactions.nil?
        final_amount += 0
      else
        user.wallet.transactions.each do |tx|
          final_amount += CryptoConverter.new(currency,tx.ticker, tx.amount.to_f).to_fiat
        end
      end
    end
    final_amount
  end

  # admin dashboard
  def total_users_deposit(users)
    final_amount = 0.0
    users.each do |user|
      user.investments.each do |item|
        unless item.status == "draft"
          amount = item.invested_amount
          rate = Currency::Converter.new(item.currency.upcase,'USD').get_rate
          final_amount += amount.to_f * rate.to_f
        end
      end
    end
    #number_to_currency(final_amount, unit: "")
    final_amount
  end

  # admin dashboard
  def all_crypto_in(ticker)
    payments = Payment.where(success: true, coin: ticker).where("coins_received > ?", 0)
    payments.sum(:coins_received)
  end

  # users with investments status active
  # @return Float in USD
  def affiliates_invested(users)
    amount = 0.0
    users.each do |user|
      user.investments.each do |inv|
        rate = Currency::Converter.new(inv.currency.upcase,'USD').get_rate
        amount += inv.invested_amount.to_f * rate.to_f
      end
    end
    amount
  end
  
  def affiliate_invested(user)
    amount = 0.0
    unless user.investments.empty?
      user.investments.each do |inv|
        rate = Currency::Converter.new(inv.currency.upcase,'USD').get_rate
        amount += inv.invested_amount.to_f * rate.to_f
      end
    end
    amount
  end
  

  def affiliates_earned(users)
    amount = 0.0
    users.each do |user|
      user.investments.each do |inv|
        rate = Currency::Converter.new(inv.currency.upcase,'USD').get_rate
        amount += inv.earned.to_f * rate.to_f
      end
    end
    amount
  end

end
