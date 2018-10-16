class RateRunJob < ApplicationJob
  queue_as :default

  CURRENCIES = ["USD","EUR","GBP","CAD","CNY","JPY","RUB"].freeze

  def perform(*args)
    rates = Rate.where(from: CURRENCIES)
    rates.each do |item|
      rate = get_rate(item.from,item.to)
      item.update(rate: rate.to_s)
      p "Rate #{item.from} -> #{item.to} updated: #{rate}"
    end
  end

  def get_rate(from,to)
    data = build_url(from,to)
    data.each { |k,v| data = v["val"] }
    data
  end

  def build_url(from,to)
    currencies = "#{from.upcase}_#{to.upcase}"
    url = "https://free.currencyconverterapi.com/api/v6/convert?q=#{currencies}&compact=y"
    ActiveSupport::JSON.decode(open(url).read)
  end
end
