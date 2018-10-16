module UsersHelper

  def user_invested(user)
    amount = 0.0
    user.investments.each do |item|
      unless item.status == "draft"
        rate = Currency::Converter.new(item.currency.upcase,'USD').get_rate
        amount_in_usd = item.invested_amount.to_f * rate
        amount += amount_in_usd
      end
    end
    amount
  end

  def user_earned(user)
    amount = 0.0
    user.investments.each do |item|
      unless item.status == "draft"
        rate = Currency::Converter.new(item.currency.upcase,'USD').get_rate
        amount_in_usd = item.earned.to_f * rate
        amount += amount_in_usd
      end
    end
    amount
  end
end
