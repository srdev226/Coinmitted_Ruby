module WalletHelper

  def wallet_total_balance(currencies, current_currency)
    result = 0
    currencies.each do |item|
      result += CryptoConverter.new(current_currency.upcase, item.ticker.upcase, item.amount.to_f).to_fiat
    end
    result
  end

  # decorator for rate volume difference
  def rate_difference(currency, ticker)
    result = CryptoConverter.new(currency.upcase, ticker, 1.0).rate_difference
    #icon = result < 0 ? "<i class='fa fa-long-arrow-down'></i>" : "<i class='fa fa-long-arrow-up'></i>"
    icon = result < 0 ? image_tag("down.png") : image_tag("up.png")
    color = result < 0 ? '<span class="current-rate down">' : '<span class="current-rate up">'
    #plus_sign = result >= 0 ? '+' : ''

    "#{color} #{number_to_percentage(result)} #{icon}</span>".html_safe
  end

  def total_user_deposit(user)
    result = 0
    user.investments.each do |invested|
      unless invested.status == "draft"
        amount = invested.invested_amount.to_f
        rate = Currency::Converter.new(invested.currency.upcase,'USD').get_rate
        result += amount * rate
      end
    end
    result
  end

  def total_user_withdrawal(wallet)
    result = 0
    #binding.pry
    wallet.transactions.each do |tx|
      amount = tx.amount.to_f
      converted_amount = CryptoConverter.new('USD', tx.ticker.upcase, amount).to_fiat
      result += converted_amount
    end
    result
  end

  def total_user_pending_withdrawal(wallet)
    result = 0
    wallet.transactions.each do |tx|
      if tx.flag == "pending"
        amount = tx.amount.to_f
        converted_amount = CryptoConverter.new('USD', tx.ticker.upcase, amount).to_fiat
        result += converted_amount
      end
    end
    result
  end

  def total_user_balance(user)
    user.profile.balance.to_f
  end

end
