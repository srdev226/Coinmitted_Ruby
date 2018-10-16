module API
  module V1
    class Payments < Grape::API
      include API::V1::Defaults

      resource :payments do

        desc 'Create payment API', headers: Base.headers_definition
        post '/', root: :payments do
          authenticate!
          investment = Investment.find_by id: params[:investment_id]
          payment = Payment.create(investment: investment)
          ticker = investment.payment_method.ticker
          #fiat_rate = get_rate("USD", @investment.currency.upcase)
          fiat_rate = Currency::Converter.new('USD', investment.currency.upcase).get_rate
          payment.get_currency(ticker, fiat_rate, true)
          converted_amount = investment.invested_amount.to_f / fiat_rate

          response = {
              currencies:  [JSON.parse(payment.currencies)],
              fiatValue:   converted_amount,
              statusUrl:   "/api/v1/payments/#{payment.id}/status"
          }
          render response
        end

        desc 'Get payment status', headers: Base.headers_definition
        get '/:id/status', root: :payments do
          authenticate!
          payment = Payment.find_by(id: params[:id])
          response = {
              success:       payment.success,
              confirmations: payment.confirmations
          }
          render json: response
        end
      end
    end
  end
end
