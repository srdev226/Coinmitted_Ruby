class PaymentsController < ApplicationController
  include ApplicationHelper

  #skip_before_action :require_login,             only: [:callback]
  skip_before_action :verify_authenticity_token, only: [:callback]
  before_action      :set_investment,            only: [:create]
  before_action      :set_payment,               only: [:address, :status, :callback]
  before_action      :check_ownership,           only: [:address, :status]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :superadmin?, only: [:index, :show]

  def index
    @payments = Payment.all
  end

  def show
    @payment = Payment.find(params[:id])
  end

  def create
    @payment = Payment.create(investment: @investment)


    ticker = @investment.payment_method.ticker
    #fiat_rate = get_rate("USD", @investment.currency.upcase)
    fiat_rate = Currency::Converter.new('USD', @investment.currency.upcase).get_rate
    @payment.get_currency(ticker, fiat_rate, true)
    converted_amount = @investment.invested_amount.to_f / fiat_rate

    response = {
      currencies:  [JSON.parse(@payment.currencies)],
      fiatValue:   converted_amount,
      onBackClick: investments_path,
      redirectTo:  "/",
      statusUrl:   "/payment/#{@payment.id}/status"
    }

    render json: response
  end

  def address
    response = @payment.get_address(params.require(:coin))
    render json: response
  end

  def status
    response = {
      success:       @payment.success,
      confirmations: @payment.confirmations
    }

    render json: response
  end

  def callback

    Rails.logger.tagged("PAYMENT") do
      Rails.logger.debug params
    end

    if params[:confirmations]
      head :unauthorized unless @payment.invoice == params.require(:invoice)
      data = params
      #invoice = data[:invoice]
      #@payment = Payment.where(invoice: invoice).first

      @payment.update(max_confirmations: params.require(:maxConfirmations))
      @payment.update(confirmations:     params.require(:confirmations))

      if data[:confirmations] >= data[:maxConfirmations]
        #in_transaction = params.require(:inTransaction)
        amount_paid = data[:inTransaction][:amount].to_f / 10**data[:inTransaction][:exp].to_f

        @payment.update(coins_received: amount_paid)
        @payment.investment.update_attributes(status: 0)

        Rails.logger.tagged("CALLBACK PAYMENT") do
          Rails.logger.debug "Investor: #{Investor}"
        end
        # Investor (User wallet)
        investor = @payment.investment.user
        investor.wallet.currencies.each do |item|
          if item.ticker.upcase == @payment.coin.upcase
            new_amount = item.amount + amount_paid
            item.update(amount: new_amount)
          end
        end

        Rails.logger.tagged("ADD CRYPTO TO USER WALLET") do
          Rails.logger.debug "Currencies: #{investor.wallet.currencies.inspect}"
        end

        render plain: @payment.invoice
      else
        render plain: 'waiting for confirmations'
      end
    #else
      #render plain: 'error'
    end
  end

  private

  def set_investment
    @investment = Investment.find(params.require(:investment))
    head :unauthorized unless @investment.user == current_user
  end

  def set_payment
    @payment = Payment.find(params.require(:id))
  end

  def check_ownership
    head :unauthorized unless @payment.investment.user == current_user
  end

end
