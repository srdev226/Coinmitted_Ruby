class Currency

  CURRENCIES = ["USD","EUR","GBP","CAD","CNY","JPY","RUB"].freeze
  CUR_SIGNS = Hash["USD"=>"$ ","EUR"=>"€ ", "GBP" =>"£ ", "CAD" => "$ ", "CNY" => "¥ ", "JPY" => "¥ ", "RUB" => "₽ "].freeze

  class Converter
    require 'open-uri'

    attr_reader :from, :to

    def initialize(from, to)
      @from, @to = from, to
    end

    def get_rate
      if from.upcase === to.upcase
        return 1
      else
        result = Rate.where(from: from.upcase, to: to.upcase).first
        if result.nil?
          return 1
        else
          result.rate.to_f
        end
      end
    end

    def build_url
      binding.pry
      to = 'USD' if to.nil?
      currencies = "#{from.upcase}_#{to.upcase}"
      url = "https://free.currencyconverterapi.com/api/v6/convert?q=#{currencies}&compact=y"
      ActiveSupport::JSON.decode(open(url).read)
    end

  end
end
