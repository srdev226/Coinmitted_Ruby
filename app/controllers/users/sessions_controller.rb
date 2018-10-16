class Users::SessionsController < Devise::SessionsController

  ############ Override the Login Attempt ##############
  ##### Check for the Two Factor Authentication #####

  def create
    @user = User.find_by_email(user_params[:email])
    
    if @user && @user.valid_password?(user_params[:password]) && @user.enable_two_factor?

      if @user.send_two_factor_authentication_code(@user.direct_otp)
        respond_to do |format|
          format.html { render 'devise/two_factor_authentication/show' }
        end
      else
        respond_to do |format|
          format.html{ redirect_to :back, alert: 'Unable to send OTP!! Try again.' }
        end
      end
    else
      super
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
