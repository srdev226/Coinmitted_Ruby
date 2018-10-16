class PhoneNumbersController < ApplicationController
  #before_action :set_phone_number, only: [:show, :edit, :update, :destroy]
  before_action :set_phone_number, only: [:destroy]
  before_action :authenticate_user!

  # GET /phone_numbers
  # GET /phone_numbers.json
  def index
    @phone_numbers = PhoneNumber.all
  end

  # GET /phone_numbers/1
  # GET /phone_numbers/1.json
  def show
  end

  # GET /phone_numbers/new
  def new
    @phone_number = PhoneNumber.new
  end

  # GET /phone_numbers/1/edit
  def edit
  end

  # POST /phone_numbers
  # POST /phone_numbers.json
  def create

    user_profile_id = edit_user? ? params[:id] : current_user.profile.id

    fn = params[:full_phone].gsub(/^\+\d+?(?=\+)/,'') # remove any extra +1+1940
    @phone_number = PhoneNumber.new(phone_number_params.merge(
      verified: false,
      profile_id: user_profile_id,
      deleted: false,
      full_number: fn
    ))

    respond_to do |format|
      if @phone_number.save && fn.split('').size > 10
        format.html { redirect_to edit_user? ? edit_user_profile_path(params[:id]) : edit_profile_path, notice: 'Phone number was successfully created.' }
        format.json { render :show, status: :created, location: @phone_number }
      else
        format.html { redirect_to edit_user? ? edit_user_profile_path(params[:id]) : edit_profile_path, alert: "Number must be present with correct format" }
        format.json { render json: @phone_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phone_numbers/1
  # PATCH/PUT /phone_numbers/1.json
  def update
    respond_to do |format|
      if @phone_number.update(phone_number_params)
        format.html { redirect_to @phone_number, notice: 'Phone number was successfully updated.' }
        format.json { render :show, status: :ok, location: @phone_number }
      else
        format.html { render :edit }
        format.json { render json: @phone_number.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_numbers/1
  # DELETE /phone_numbers/1.json
  def destroy
    #if edit_user? || current_user.profile.phone_numbers.ids.include?(params[:id])
    #end
    #PhoneNumber.find(46).profile.id
    @phone_number.destroy
    respond_to do |format|
      format.html { redirect_to redirect_path, notice: 'Phone number was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone_number
      if edit_user?
        @phone_number = PhoneNumber.find(params[:id])
      else
        @phone_number = PhoneNumber.where(id: params[:id], profile_id: current_user.profile.id).first
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_number_params
      params.require(:phone_number).permit(
        :number, :verified, :profile_id, :deleted,
        :dial_code, :full_number
      )
    end

    def edit_user?
      current_user.admin? && params[:id].present?
    end

    def redirect_path
      edit_user? ? edit_user_profile_path(@phone_number.profile.id) : edit_profile_path
    end
end
