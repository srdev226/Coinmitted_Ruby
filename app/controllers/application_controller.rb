class ApplicationController < ActionController::Base

  #before_action :set_profile # move it to user sign up
  before_action :set_currency
  before_action :currency_val
  before_action :currency_sign
  before_action :set_locale
  before_action :set_wallet

  after_action :track_action
  before_action :set_variables

  helper_method :superadmin?
  helper_method :admin_role?
  helper_method :edit_user?

  before_action :configure_permitted_parameters, if: :devise_controller?

  #def default_url_options
    #{ locale: I18n.locale }
  #end

  def set_locale
    if current_user
      current_user.profile.language if current_user.profile.present?
    else
      I18n.default_locale
    end
  end

  def superadmin?
    @superadmin ||= current_user.superadmin if current_user
  end

  def edit_user?
    if current_user.admin? && params[:user_id]
      return true
    else
      return false
    end
  end

  def admin_role?
    if current_user.nil?
      redirect_to new_user_session_path, alert: "Please sign in"
    else
      redirect_to root_path, alert: "You don't have permission to view this page" unless current_user.admin?
    end
  end

  def set_currency
    if current_user
      @currency = current_user.profile.currency.upcase if current_user.profile.present?
      cookies.permanent[:currency] = @currency
    else
      if cookies[:currency].present?
        @currency = cookies[:currency]
      else
        @currency = "USD"
        cookies.permanent[:currency] = "USD"
      end
    end

  end

  def currency_val
    @cur_val = Currency::CURRENCIES
  end

  def currency_sign
    @cur_sign = Currency::CUR_SIGNS
  end

  protected

    def track_action
      ahoy.track "Page hit", request.original_url
    end

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [profile_attributes: [:name, :currency]])
      devise_parameter_sanitizer.permit(:account_update, keys: [account_attributes: [:name, :currency]])
    end

    def after_sign_out_path_for(resource_or_scope)
      super
      #if current_user.admin?
        #users_visits_path
      #else
        #super
      #end
    end

    def after_sign_in_path_for(resource_or_scope)
      if current_user.admin?
        #users_visits_path
        admin_index_path
      else
        super
      end
    end

    def set_wallet
      if current_user.present?
        @wallet = Wallet.where(user_id: current_user.id).first
      else
        []
      end
    end

    def set_variables
      puts "aa"
      @users_count = User.where.not(role: :admin).count
      @page_hits = Ahoy::Event.count
      @visitors_count = Ahoy::Visit.count
      @url = [
        new_user_registration_url,
        '/',
        current_user.affiliate_token
      ].join if user_signed_in?
     # affiliate cun be anyone && current_user.affiliate?
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end
end
