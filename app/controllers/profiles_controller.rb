class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_role?, only: [:index]
  before_action :set_profile, only: [:show, :edit, :update, :destroy, :password_update]


  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    @two_factor = current_user[:enable_two_factor]
    if edit_user?
      @profile = Profile.find(params[:id])
      @profile.admin_edit_user = true
      
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def password_update
    user = current_user.valid_password?(params[:current_password])
    if user == false && !current_user.admin?
      redirect_to edit_profile_path(@profile), alert: "Current password not match"
    else
      if @profile.user.update(password: params[:profile][:user][:password], password_confirmation: params[:profile][:user][:password_confirmation])
        bypass_sign_in(@profile.user) unless current_user.admin?
        redirect_to current_user.admin? ? edit_user_profile_path(@profile) : edit_profile_path(@profile), notice: "Profile was successfully updated."
      else
        redirect_to current_user.admin? ? edit_user_profile_path(@profile) : edit_profile_path(@profile), alert: "Password mismatch"
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update

    if profile_params[:avatar].present?
      @profile.avatar.attach(profile_params[:avatar])
    end

    # If click desable or enable pin
    # will trigger this code
    if profile_params[:wallet_pin_enabled].present?
      @profile.generate_pin = true
    end

    respond_to do |format|
      if @profile.update(profile_params)
        if edit_user?
          format.html { redirect_to edit_user_profile_path(@profile.id), notice: 'Profile was successfully updated.' }
        else
          format.html { redirect_to edit_profile_path, notice: 'Profile was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @profile }
        #format.js
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
        #format.js { render json: "error" }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.update(deleted: true)
    #@profile.user
    #@profile.destroy
    redirect_to new_user_session_path
  end

  def auth_factor
    @number = PhoneNumber.where(profile_id: current_user.profile.id, verified: true).first
    
    if @number.present?
      begin
        @number.send_otp
      rescue StandardError => e
        redirect_to edit_profile_path, alert: "Wrong number format, please check your phone number and try again. Error: #{e}"
      end
      respond_to do |format|
        format.js{}
      end
    else
      redirect_to edit_profile_path, alert: "Verify your phone number to enable the tow factor authentication."
    end
  end

  def enable_two_factor
    begin
      @number = PhoneNumber.where(id: params[:number], profile_id: current_user.profile.id).first
    rescue StandardError => e
      redirect_to edit_profile_path, alert: "Error: #{e}"
    end
    if params[:code].to_s == @number.verification_code.to_s
      current_user.update(enable_two_factor: true)
      redirect_to edit_profile_path, notice: "Your Two-Factor Authentication is enabled"
    else
      flash[:alert] = "Enter the correct code"
      render :new
    end
  end
  
  # Resent OTP
  def resend_otp
    @number = PhoneNumber.where(profile_id: current_user.profile.id, verified: true).first
    @success = true if @number.send_otp
    respond_to do |format|
      format.js {}
    end
  end 


  def send_phone_verification
    @response = Authy::PhoneVerification.start(
      via: 'sms',
      country_code: params[:country_code],
      phone_number: params[:phone_number]
    )
    respond_to do |format|
      if @response.ok?
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify_phone
    @response = Authy::PhoneVerification.check(
      verification_code: params[:code],
      country_code: params[:country_code],
      phone_number: params[:phone_number]
    )
    respond_to do |format|
      if @response.ok?
        create_phone_number
        format.json { render json: {}, status: :ok }
      else
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    def create_phone_number
      phone_number = current_user.profile.phone_numbers.find_or_initialize_by(
        number: params[:phone_number]
      )
      phone_number.verified = true
      phone_number.verification_code = params[:code]
      phone_number.dial_code = params[:country_code]

      phone_number.full_number = params[:country_code] + params[:phone_number]
      phone_number.save!
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      if edit_user?
        @profile = Profile.where(id: params[:id], deleted: false).first
      else
        @profile = Profile.where(id: current_user.profile.id, deleted: false).first
      end
      if @profile.nil?
        redirect_to new_user_session_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      #params.fetch(:profile, {})
      params.require(:profile).permit(
        :name, :bio, :gender, :country, :member, :language, :currency, :notification_news,
        :notification_deposit, :notification_payout, :notification_payout, :notification_alert,
        :deleted, :wallet_pin_enabled, :wallet_pin, :user_id, :avatar,
        user_attributes: [:id, :email, :password, :password_confirmation, :current_password],
        phone_numbers_attributes: [:id, :number]
      )
    end

    def user_params
      params.require(:profile).permit(:user => [:password, :password_confirmation])
    end

    def set_wallet_pin
      #EncryptorService::encrypt(params[:profile][:wallet_pin]) if profile_params[:wallet_pin].present?
    end

    def edit_user?
      if current_user
        current_user.admin? && params[:id].present?
      end
    end

end
