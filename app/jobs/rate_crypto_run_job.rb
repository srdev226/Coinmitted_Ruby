class RateCryptoRunJob < ApplicationJob
  queue_as :default

  CURRENCIES = ["BTC","LTC","ETH"].freeze

  # Fields
  # from, to, rate, old_rate
  def perform(*args)
    rates = Rate.where(from: CURRENCIES)
    rates.each do |item|
      rate = get_rate(item.to, item.from)
      old_rate = item.rate
      item.update(rate: rate.to_s, old_rate: old_rate)
      p "Rate #{item.from} -> #{item.to} updated: #{rate}"
    end
  end

  def get_rate(fiat, ticker)
    $rates ||= nil
    $currency = $currency.present? && $currency.upcase == fiat.upcase ? fiat : nil
    #$currency = (fiat.upcase == $currency.upcase ? fiat : nil) # set to nil if currency changed

    fiat = fiat.downcase
    ticker = ticker.downcase

    unless $rates.present? && $currency.present?
      url = "https://api.paybear.io/v2/exchange/#{fiat}/rate"
      response = ActiveSupport::JSON.decode(open(url).read)
      if response['success']
        $rates = response['data']
        $currency = fiat # set currency
      end
    end

    $rates[ticker] ? $rates[ticker]['mid'] : nil
  end
end
