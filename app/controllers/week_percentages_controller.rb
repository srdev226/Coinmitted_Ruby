class WeekPercentagesController < ApplicationController

  # TODO Make autherization for ADMIN only
  before_action :authenticate_user!

  before_action :set_week_percentage, only: [:show, :edit, :update, :destroy]

  # GET /week_percentages
  # GET /week_percentages.json
  def index
    @week_percentages = WeekPercentage.order(first_date: :asc)
  end

  # GET /week_percentages/1
  # GET /week_percentages/1.json
  def show
  end

  # GET /week_percentages/new
  def new
    @week_percentage = WeekPercentage.new
  end

  # GET /week_percentages/1/edit
  def edit
  end

  # POST /week_percentages
  # POST /week_percentages.json
  def create
    date = params[:week_percentage][:date]
    splitted = date.split(' ')
    @week_percentage = WeekPercentage.new(week_percentage_params.merge(first_date: splitted[0], last_date: splitted[2]))

    ##
    # Create payouts
    ##

    respond_to do |format|
      if @week_percentage.save
        format.html { redirect_to @week_percentage, notice: 'Week percentage was successfully created.' }
        format.json { render :show, status: :created, location: @week_percentage }
      else
        format.html { render :new }
        format.json { render json: @week_percentage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /week_percentages/1
  # PATCH/PUT /week_percentages/1.json
  def update
    respond_to do |format|
      if @week_percentage.update(week_percentage_params)
        format.html { redirect_to @week_percentage, notice: 'Week percentage was successfully updated.' }
        format.json { render :show, status: :ok, location: @week_percentage }
      else
        format.html { render :edit }
        format.json { render json: @week_percentage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /week_percentages/1
  # DELETE /week_percentages/1.json
  def destroy
    @week_percentage.destroy
    respond_to do |format|
      format.html { redirect_to week_percentages_path, notice: 'Week percentage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week_percentage
      @week_percentage = WeekPercentage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def week_percentage_params
      params.require(:week_percentage).permit(:first_date, :date, :last_date, :percentage)
    end
end
