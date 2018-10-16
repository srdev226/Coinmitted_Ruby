class Users::VisitsController < ApplicationController
  def index
    @visits = Ahoy::Visit.includes(:events).order(started_at: :desc)
  end

  def show
    @visit = Ahoy::Visit.includes(:events).find_by(id: params[:id])
    @events = @visit.events.group(:properties).count
  end
end
