class PayoutsCheckJob < ApplicationJob
  queue_as :default

  def perform(*args)
    payouts = Payout.where(pay_date: Date.today, status: 0)
    payouts.each do |item|
      PayoutCalculation.new(item).calculate

      # Increase Earned of investment of this payout
      earned = item.amount.to_f + item.investment.earned.to_f
      item.investment.update_attributes(earned: earned)

      # Increase user's balance in profile
      # Keep balance in USD, convert before save
      user = item.investment.user
      balance = user.profile.balance
      rate = Currency::Converter.new("USD",item.investment.currency.upcase).get_rate
      amount = earned.to_f * rate
      user.profile.update(balance: balance.to_f + amount )
    end
  end
end
