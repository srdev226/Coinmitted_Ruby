module API
  module V1
    class Registrations < Grape::API
      include API::V1::Defaults

      resource :users do
        desc 'Signup API'
        params do
          requires :email, type: String, desc: 'Email of User'
          requires :password, type: String, desc: 'Password of User'
          requires :uuid, type: String, desc: 'Device Id'
        end
        post '/', root: :users do
          user = User.where('lower(email) = ?', params[:email].downcase).limit(1)[0]
          if user.present?
            render error: 'Email already in use, please try logging in'
          else
            user = User.create(email: params[:email], password: params[:password])
            if user.errors.present?
              render error: user.errors.full_messages.first
            else
              # UserMailer.confirmation_mail(user.email, user.name, user.email_code).deliver
              Profile.create user_id: user.id, name: "Subscribed User", bio: "Coinmitted investor", language: "en", currency: "USD", deleted: false, membership: 0
              wallet_params = { user_id: user.id }
              wallet = ::Wallet.create(wallet_params)
              currency_params = [{ name: "Bitcoin", ticker: "BTC", wallet_id: wallet.id, amount: 0.0 },{ name: "Etherium", ticker: "ETH", wallet_id: wallet.id, amount: 0.0 },{ name: "Litecoin", ticker: "LTC", wallet_id: wallet.id, amount: 0.0 }]
              currency_params.each do |item|
                WalletCurrency.create(item)
              end
              device = user.devices.create uuid: params[:uuid], os: (params[:os] || 'ios')
              render id: user.id,
                     email: user.email,
                     api_token: device.api_token
            end
          end
        end
      end
    end
  end
end
