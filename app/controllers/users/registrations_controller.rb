class Users::RegistrationsController < Devise::RegistrationsController

  # GET new
  def new
    user_type = params[:user]
    if user_type == 'affiliate'
      session[:role] = 'affiliate'
      @title = "Welcome to affiliates sign_up page"
    elsif user_type == 'investor' || ''
      session[:role] = 'investor'
      @title = "Welcome to investors sign_up page"
    else
      not_found
    end

    affiliate_token = params[:affiliate]
    referal = User.find_by(affiliate_token: affiliate_token)
    if affiliate_token.blank? || referal.nil?
      session.delete(:referal_id)
    else
      session[:role] = 'investor'
      session[:referal_id] = referal.id
      referal.update_affiliate_link_visits
    end

    super
  end

  def create
    super do
      if session[:referal_id]
        referal = User.find(session[:referal_id])
        referal.affiliates << resource
      end
      resource.role = session[:role]
      resource.save

      generate_profile(resource)
      generate_wallet(resource)
    end
  end


  def after_sign_up_path_for(resource)
    current_user.investor? ? start_wizard_investment_path : root_path
  end

  private

  # generate user's profile
  # on new User sign up
  def generate_profile(user)
    if user.profile.nil?
      profile_params = { user_id: user.id, name: "Subscribed User", bio: "Coinmitted investor", language: "en", currency: "USD", deleted: false, membership: 0 }
      Profile.create(profile_params) if user.profile.nil?
    end
  end

  # Generate User's Wallet with crypto-currencies
  # on User sign up
  def generate_wallet(user)
    if user.wallet.nil?
      wallet_params = { user_id: user.id }
      wallet = Wallet.create(wallet_params)
      currency_params = [{ name: "Bitcoin", ticker: "BTC", wallet_id: wallet.id, amount: 0.0 },{ name: "Ethereum", ticker: "ETH", wallet_id: wallet.id, amount: 0.0 },{ name: "Litecoin", ticker: "LTC", wallet_id: wallet.id, amount: 0.0 }]
      currency_params.each do |item|
        WalletCurrency.create(item)
      end
    end
  end

end
