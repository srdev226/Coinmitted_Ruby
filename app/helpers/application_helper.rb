module ApplicationHelper


  # Crypto currency fiat rate
  def fiat_rate(from, to, amount)
    if from
     rate = get_fiat_rate(from,to)
    else
      0.0
    end
    if amount && rate
      (amount / rate).round(8)
    else
      0.0
    end
  end

  def get_fiat_rate(fiat, ticker)
    $rates ||= nil

    fiat = fiat.downcase
    ticker = ticker.downcase

    unless $rates.present?
      url = "https://api.paybear.io/v2/exchange/#{fiat}/rate"
      response = ActiveSupport::JSON.decode(open(url).read)
      if response['success']
        $rates = response['data']
      end
    end

    $rates[ticker] ? $rates[ticker]['mid'] : nil
  end

  # TODO move to Currency::Converter
  def get_rate(from,to)
    if from.upcase === to.upcase
      return 1
    else
      result = Rate.where(from: from.upcase, to: to.upcase).first
      result.rate.to_f
    end
  end

  # TODO remove ASAP
  def amount_in_currency(from,to, amount)
    rate = Rate.where(from: from, to: to).first
    amount.to_f * rate.to_f
  end

  # Resize images to square size
  def image_options(size)
    {auto_orient: true,
    gravity: "north", # center, north
    resize: "#{size}^",
    crop: "#{size}+0+0"}
  end

  def affiliate_token_valid?(token)
    User.find_by(affiliate_tiken: token)
  end
end
