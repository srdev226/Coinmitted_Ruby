class Users::AffiliatesController < ApplicationController
  before_action :set_users_compaign, only: [:show, :edit, :update, :destroy]

  def index
    @users_campaigns = current_user.affiliates
    @users = current_user.affiliates
  end
end
