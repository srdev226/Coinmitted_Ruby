class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet

  def show
  end

  private

  def set_wallet
    super
  end
end
