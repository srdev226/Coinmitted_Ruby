require 'grape-swagger'
module API
  module V1
    class Base < Grape::API
      def self.headers_definition
        {
            'Authorization' => {
                description: 'User API token',
                required: true
            }
        }
      end

      helpers do
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless current_user
        end

        def current_user
          # find token. Check if valid.
          token = Device.where(api_token: request.headers['Authorization']).first
          if token
            @current_user = User.find(token.user_id)
            #TODO need to have profile and wallets for all the users
            ::Profile.create user_id: @current_user.id, name: "Subscribed User", bio: "Coinmitted investor", language: "en", currency: "USD", deleted: false, membership: 0 if @current_user.profile.blank?
            if @current_user.wallet.nil?
              wallet_params = { user_id: @current_user.id }
              wallet = ::Wallet.create(wallet_params)
              #wallet = ::Wallet.where(user_id: current_user.id).first
              #currency_params = { name: "Bitcoin", ticker: "BTC", wallet_id: wallet.id, amount: 0.0 }
              currency_params = [{ name: "Bitcoin", ticker: "BTC", wallet_id: wallet.id, amount: 0.0 },{ name: "Etherium", ticker: "ETH", wallet_id: wallet.id, amount: 0.0 },{ name: "LItecoin", ticker: "LTC", wallet_id: wallet.id, amount: 0.0 }]
              currency_params.each do |item|
                ::WalletCurrency.create(item)
              end
            end
            @current_user
          else
            false
          end
        end

        def set_currency
          if current_user
            if current_user.profile.present?
              @currency = current_user.profile.currency.upcase
            else
              @currency = "USD"
            end
          else
            @currency = "USD"
          end

        end

        def currency_val
          @cur_val = Currency::CURRENCIES
        end

        def currency_sign
          @cur_sign = Currency::CUR_SIGNS
        end

        def generate_payouts(investment)

          case investment.payout_frequency.name
          when "weekly"
            PayoutGenerator.new(investment).generate_weekly_payouts
            #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_weekly
          when "twice"
            PayoutGenerator.new(investment).generate_twice_payouts
            #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_twice
          when "monthly"
            PayoutGenerator.new(investment).generate_monthly_payouts
            #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_monthly
          when "end_of_period"
            PayoutGenerator.new(investment).generate_end_of_period_payouts
            #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_end_of_period
          end
        end

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

        def new_user_registration_url
          'http://coinmitted.herokuapp.com/sign_up'
        end

        include DashboardsHelper
        include WalletHelper
      end

      mount API::V1::Passwords
      mount API::V1::Registrations
      mount API::V1::Sessions
      mount API::V1::Investments
      mount API::V1::Users
      mount API::V1::PhoneNumbers
      mount API::V1::Dropdown
      mount API::V1::Wallet
      mount API::V1::Payments
      mount API::V1::Affiliates

      add_swagger_documentation(api_version: 'v1', hide_documentation_path: true, mount_path: '/api/v1/swagger_doc', hide_format: true)
    end
  end
end
