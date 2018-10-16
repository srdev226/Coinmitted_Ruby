class Users::CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_users_campaign, only: [:show, :edit, :update, :destroy]

  def index
    @users_campaigns = Users::Campaign.where(user_id: current_user.id)
  end

  def show; end

  def new
    @users_campaign = Users::Campaign.new
  end

  def edit; end

  def create
    @users_campaign = Users::Campaign.new(users_campaign_params)
    @users_campaign.user = current_user
    respond_to do |format|
      if @users_campaign.save
        format.html { redirect_to @users_campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @users_campaign }
      else
        format.html { render :new }
        format.json { render json: @users_campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @users_campaign.destroy
    respond_to do |format|
      format.html { redirect_to users_campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def set_users_campaign
    @users_campaign = Users::Campaign.where(id: params[:id], user_id: current_user.id).first
  end

  def users_campaign_params
    params.require(:users_campaign).permit(:name)
  end
end
