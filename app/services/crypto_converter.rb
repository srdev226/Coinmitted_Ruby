class CryptoConverter
  require 'open-uri'

  attr_reader :fiat, :ticker, :amount

  def initialize(fiat,ticker,amount)
    @fiat, @ticker, @amount = fiat, ticker, amount
  end

  def to_fiat
    rate = get_rate(fiat, ticker)
    if amount && rate
      (amount * rate).round(2)
    else
      0.0
    end
  end

  def to_crypto
    rate = get_rate(fiat, ticker)
    if amount && rate
      (amount / rate).round(8)
    else
      0.0
    end
  end

  def rate_difference
    record = Rate.where(from: ticker.upcase, to: fiat.upcase).first
    cur_rate = record.rate
    old_rate = record.old_rate

    old_rate.to_f * 100 / cur_rate.to_f - 100
  end

  private

  # New implementation of geting rates from database
  def get_rate(fiat, ticker)
    result = Rate.where(from: ticker.upcase, to: fiat.upcase).first
    if result.nil?
      return 1
    else
      result.rate.to_f
    end
  end

  #def get_rate(fiat, ticker)
    #$rates ||= nil
    #$currency = (fiat.upcase == $currency.upcase ? fiat : nil) # set to nil if currency changed

    #fiat = fiat.downcase
    #ticker = ticker.downcase

    #unless $rates.present? && $currency.present?
      #url = "https://api.paybear.io/v2/exchange/#{fiat}/rate"
      #response = ActiveSupport::JSON.decode(open(url).read)
      #if response['success']
        #$rates = response['data']
        #$currency = fiat # set currency
      #end
    #end

    #$rates[ticker] ? $rates[ticker]['mid'] : nil
  #end

end
