class CurrencyConverterController < ApplicationController

  include Response

  def convert
    currency = params[:currency]
    amount = params[:amount].to_f

    result = {}
    ['btc','ltc','eth'].each do |ticker|
      rate = get_rate(currency, ticker)
      converted = (amount.to_f / rate).round(8)
      result[ticker.upcase] = converted
    end

    json_response(result)

  end

  def show_crypto
    currency = params[:currency]
    amount = params[:amount].to_f
    ticker = params[:ticker]
    result = CryptoConverter.new(currency.upcase, ticker.upcase, amount).to_crypto

    json_response({"data":result})
  end

  def get_rate(fiat, ticker)
    fiat = fiat.downcase
    ticker = ticker.downcase
    url = "https://api.paybear.io/v2/exchange/#{fiat}/rate"
    response = ActiveSupport::JSON.decode(open(url).read)
    if response['success']
      rates = response['data']
    end

    rates[ticker] ? rates[ticker]['mid'] : nil
  end
end
