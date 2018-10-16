module API
  module V1
    class Wallet < Grape::API
      include API::V1::Defaults

      resource :wallet do

        desc 'Wallet Get API', headers: Base.headers_definition
        get '/', root: :wallet do
          authenticate!
          set_currency
          wallet = ::Wallet.where(user_id: current_user.id).first
          currencies = []
          wallet.currencies.each do |item|
            currencies << { currency: item.ticker, amount: item.amount.to_f, cur_sign: Currency::CUR_SIGNS[@currency], amount_in_currency: CryptoConverter.new(@currency.upcase, item.ticker.upcase, item.amount.to_f).to_fiat }
          end
          transactions = []
          wallet.transactions.each do |transaction|
            transactions << {
                flag: transaction.flag,
                created_at_month: transaction.created_at.strftime("%b").upcase,
                created_at_date: transaction.created_at.strftime("%d"),
                name: transaction.name,
                address: transaction.address,
                amount: transaction.amount.to_f,
                ticker: transaction.ticker.upcase,
                amount_in_currency: CryptoConverter.new(@currency.upcase, transaction.ticker, transaction.amount.to_f).to_fiat,
                cur_sign: Currency::CUR_SIGNS[@currency]
            }
          end
          render currencies: currencies,
                 wallet_total_balance: wallet_total_balance(wallet.currencies, @currency),
                 currency: @currency,
                 cur_sign: Currency::CUR_SIGNS[@currency],
                 transactions: transactions
        end

        desc 'Wallet Currencies API', headers: Base.headers_definition
        get '/currencies', root: :wallet do
          authenticate!
          set_currency
          wallet = ::Wallet.where(user_id: current_user.id).first
          currencies = []
          wallet.currencies.each do |item|
            currencies << { currency: item.ticker, amount: item.amount.to_f, cur_sign: Currency::CUR_SIGNS[@currency], amount_in_currency: CryptoConverter.new(@currency.upcase, item.ticker.upcase, item.amount.to_f).to_fiat }
          end
          render currencies: currencies
        end

        desc 'Withdraw wallet API', headers: Base.headers_definition
        post '/withdraw', root: :wallet do
          authenticate!
          set_currency
          wallet = ::Wallet.where(user_id: current_user.id).first
          transaction = Transaction.new(wallet_id: wallet.id, name: "Withdraw to #{params[:ticker]}", ticker: params[:ticker], address: params[:address], amount: params[:amount])
          to_transfer = params[:amount]
          enough_amount = false
          wallet.currencies.each do |item|
            if item.ticker == params[:ticker] && item.amount.to_f >= to_transfer.to_f
              enough_amount = true
              break
            end
          end
          if enough_amount
            if transaction.save
              render success: 'Transaction was successfully created.'
            else
              render error: transaction.errors.full_messages.first
            end
          else
            render error: "You don't have sufficient amount in #{params[:ticker]}"
          end
        end
      end
    end
  end
end
