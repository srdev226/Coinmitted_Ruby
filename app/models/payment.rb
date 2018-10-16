require "open-uri"

class Payment < ApplicationRecord
  belongs_to :investment

  #after_create :set_currency
  after_update :update_success

  PAYBEAR_SECRET = Rails.application.credentials.paybear_secret
  DOMAIN = Rails.application.credentials.domain

  def get_address(coin)
    callback_url = CGI.escape("#{DOMAIN}/payments/#{id}/callback")
    url = "https://api.paybear.io/v2/#{coin.downcase}/payment/#{callback_url}?token=#{PAYBEAR_SECRET}"
    api_resp     = api_call(url)

    update(coin: coin)
    update(invoice: api_resp["data"]["invoice"])
    api_resp["data"]["address"]
    #{error: nil, address: api_resp["data"]["address"]}
  end

  def get_currency(ticker, fiat_rate, get_address = false)
    rate = get_rate(ticker)
    #rate = get_fiat_rate(fiat, ticker)

    if rate
      fiat_value = investment.invested_amount.to_f
      coins_value = (fiat_value / rate).round(8)

      ticker = ticker.downcase
      currencies = get_currencies
      if currencies[ticker]
        currency = currencies[ticker]
        currency[:coinsValue] = coins_value
        if get_address
          currency[:address] = get_address(ticker)
        else
          currency[:currencyUrl] = "/payments/#{id}/address/#{ticker}"
        end
        currency
      end
    end

    #Rails.logger.tagged("PAYMENT") do
      #Rails.logger.debug "------------currency updateing #{currency.to_json}"
    #end
    update(currencies: currency.to_json)
  end

  def fiat_rate(from, to)
   get_fiat_rate(from,to)
  end

  private

  def api_call(url)
    resp = ActiveSupport::JSON.decode(open(url).read)
    raise unless resp["success"]

    resp
  end


  def get_currencies
    $currencies ||= nil

    if $currencies.nil?
      url = "https://api.paybear.io/v2/currencies?token=#{PAYBEAR_SECRET}"
      response = ActiveSupport::JSON.decode(open(url).read)

      if response['success']
        $currencies = response['data']
      end
    end
    $currencies
  end

  def set_currencies
    api_resp  = api_call("https://api.paybear.io/v2/currencies?token=#{PAYBEAR_SECRET}")
    rates     = get_rates
    responses = api_resp["data"].map do |coin, response|
      response["coinsValue"]  = (investment.invested_amount / rates[coin]["mid"]).round(8)
      response["currencyUrl"] = "/payments/#{id}/address/#{coin}"
      response
    end

    #update(currencies: responses.to_json)
  end

  def get_fiat_rate(fiat, ticker)
    fiat = fiat.downcase
    ticker = ticker.downcase
    url = "https://api.paybear.io/v2/exchange/#{fiat}/rate"
    response = ActiveSupport::JSON.decode(open(url).read)
    if response['success']
      rates = response['data']
    end

    rates[ticker] ? rates[ticker]['mid'] : nil
  end

  def get_rate(cur_code)
    rates = get_rates
    cur_code = cur_code.downcase

    rates[cur_code] ? rates[cur_code]['mid'] : nil
  end

  def get_rates
    $rates ||= nil

    if $rates.nil?
      url = 'https://api.paybear.io/v2/exchange/usd/rate'
      response = ActiveSupport::JSON.decode(open(url).read)

      if response['success']
        $rates = response['data']
      end
    end
    $rates
  end

  def update_success
    return unless max_confirmations && confirmations && (confirmations >= max_confirmations) && (success.nil?)

    update(success: true)
  end
end
