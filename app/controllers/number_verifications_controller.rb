
class NumberVerificationsController < ApplicationController
  before_action :authenticate_user!
  require 'twilio-ruby'

  # GET /number_verifications/new
  def new

    begin
      @number = PhoneNumber.where(id: params[:number], profile_id: current_user.profile.id).first
    rescue StandardError => e
      redirect_to edit_profile_path, alert: "Error: #{e}"
    end
    # without zero
    code = 5.times.map { rand(1..9) }.join

    @number.update(verification_code: code)
    @client = Twilio::REST::Client.new

    begin
      @client.api.account.messages.create(
        from: Rails.application.credentials.twilio_phone_number,
        to: @number.full_number,
        body: "Coinmitted verification code: #{code}"
      )
    rescue StandardError => e
      redirect_to edit_profile_path, alert: "Wrong number format, please check your phone number and try again. Error: #{e}"
    end
  end

  # POST /number_verifications
  # POST /number_verifications.json
  def create
    begin
      @number = PhoneNumber.where(id: params[:number], profile_id: current_user.profile.id).first
    rescue StandardError => e
      redirect_to edit_profile_path, alert: "Error: #{e}"
    end

    if params[:code].to_s === @number.decrypt_code.to_s
      @number.update(verified: true)
      redirect_to edit_profile_path, notice: "Your phone number #{@number.number} verified"
    else
      flash[:alert] = "Wrong code"
      render :new
    end

  end

end
