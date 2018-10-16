class InvestmentsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :set_investment, only: [:show, :edit, :update, :destroy]

  # GET /investments
  # GET /investments.json
  def index
    @investment = Investment.new
    @wizard_investment = PayoutFrequency::all()
    status = params[:status] == 'active' ? 'active' : 'payment'
    
    @timeframe = []
    (1..24).each do |t|
      @timeframe << [t.to_s + " Months", t]
    end
    if edit_user?
        @investments = Investment.order(id: :desc).where(user_id: params[:user_id])
        @investments = @investemnts.where(status: status) if params[:status] && params[:status] != 'all'
    else
        @investments = Investment.order(id: :desc).where(user_id: current_user.id)
        @investments = @investments.where(status: status) if params[:status] && params[:status] != 'all'
    end
  end

  def certificate

    begin
      @investment = Investment.find(params[:id])
      respond_to do |f|
        f.html
        f.pdf do
          pdf = CertificatePdf.new(@investment, view_context)
          send_data pdf.render,
            filename: "certificate_#{@investment.id}",
            type: 'application/pdf',
            disposition: 'inline'
        end
      end
    rescue StandardError => error
      redirect_to investments_path, alert: "Certificate can't be downloaded, please contact support #{error}"
    end
  end

  # GET /investments/1
  # GET /investments/1.json
  def show
  end

  # GET /investments/new
  def new
    @investment_plans = InvestmentPlan::all()
    session[:invest_attributes] = nil
    @investment = Investment.new
  end

  # GET /investments/1/edit
  def edit
    @statuses = Investment.statuses
  end

  # POST /investments
  # POST /investments.json
  def create
    @investment_plans = InvestmentPlan::all()
    @investment = Investment.new(investment_params)
    session[:invest_attributes] = nil
    #current_step = params[:current_step]
    #@investment = Investment.new(investment_params.merge(user_id: current_user.id))


    respond_to do |format|
      if @investment.save
        format.html
        format.js
        #format.html { redirect_to investments_path, notice: 'Investment was successfully created.' }
        #render json: @invetsment
      else
        render json: "error"
      end
    end
  end

  # PATCH/PUT /investments/1
  # PATCH/PUT /investments/1.json
  def update
    respond_to do |format|
      if @investment.update(investment_params_update)
        format.html { redirect_to investments_path, notice: 'Investment was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @investment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /investments/1
  # DELETE /investments/1.json
  def destroy
    respond_to do |format|
      if edit_user?
        return_investment
        @investment.destroy
        format.html { redirect_to edit_user? ? user_investments_path : investments_url, notice: 'Investment was successfully destroyed.' }
      else
        format.html { redirect_to user_investments_path, alert: 'Something went wrong' }
      end
    end
  end

# (start name timeframe payout amount payment review)

  def get_end_date
    open_date = Time.now
    end_date = open_date.months_since(params[:months].to_i)
    render json: {open_date: open_date, end_date: end_date}
  end

  def get_frequency
    if params[:freq_id].nil?
      payout_frequency = PayoutFrequency::where(id: params[:payout_freq_id].to_i).all()
      render json: {name: payout_frequency[0].name}
    else
      payout_frequency = PayoutFrequency::all()
      payout_frequency = payout_frequency[params[:freq_id].to_i]
      render json: {payout_frequency: payout_frequency}
    end
  end

  def get_range
    investment_plan = InvestmentPlan::where(id: params[:plan_id].to_i).all()
    render json: {min:investment_plan[0].min, max:investment_plan[0].max}
  end

  def get_payment_method_id
    payment_method = PaymentMethod::where(name: params[:method_name]).all()
    render json: {method_id:payment_method[0].id}
  end

  def get_edit_investment
    investment = Investment::where(id: params[:id]).all()
    render json: {investment: investment[0]}
  end

  def get_status
    status = {"active" => 0, "draft" => 1, "ended" => 2, "payment" => 3}
    stat = params[:stat]
    render json: {status: status[stat]}
  end

  def confirm
    currency = params[:currency]
    investment = Investment.find_or_initialize_by(
        id: params[:id]
    )
    
    investment.name = params[:name]
    investment.investment_plan_id = params[:invested_plan_id].to_i
    investment.invested_amount = params[:invested_amount].to_f
    investment.open_date = params[:open_date].to_date
    investment.end_date = params[:end_date].to_date
    investment.user_id = params[:user_id].to_i
    investment.timeframe = params[:timeframe].to_i
    investment.payout_frequency_id = params[:payout_frequency_id].to_i
    investment.payment_method_id = params[:payment_method_id].to_i
    investment.expected_return = params[:expected_return].to_f
    investment.investment_earning = params[:investment_earning].to_f
    investment.currency = currency.downcase
    investment.skip_validation = true
    investment.status = params[:status].to_i
    if investment.save
      render json: {ret_val: "success"}
    else
      render json: {ret_val: "failed"}
    end
  end
  private

    def return_investment
      amount_to_return = @investment.invested_amount.present? ? @investment.invested_amount : 0
      profile = Profile.find(@investment.user.profile.id)
      # if amount more that 0 then return money
      if amount_to_return > 0
        rate = Currency::Converter.new(@investment.currency.upcase,'USD').get_rate
        amount_to_return = amount_to_return * rate
        profile.update(balance: profile.balance + amount_to_return)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_investment
      @investment = Investment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def investment_params
      params.require(:investment).permit(
        :name, :invested_amount, :status, :open_date, :end_date,
        :user_id, :timeframe, :payout_frequency_id, :payment_method_id
      )
    end

    # Keep strong params for edit other that for create.
    # Removed: :invested_amount, :open_date
    def investment_params_update
      params.require(:investment).permit(
        :investment_plan_id, :name, :status, :end_date,
        :user_id, :timeframe, :payout_frequency_id, :payment_method_id
      )
    end

    def investment_wizard_params
      params.require(:investment_wizard).permit(
        :investment_plan_id, :name, :invested_amount, :status, :open_date, :end_date,
        :user_id, :timeframe, :payout_frequency_id, :payment_method_id, :expected_return,
        :currency
      )
    end

    def edit_user?
      params[:user_id].present? && current_user.admin?
    end
    # Fuctions wizard_investments
    def wizard_investment_next_step(step)
      Wizard::Investment::STEPS[Wizard::Investment::STEPS.index(step) + 1]
    end

    def wizard_investment_for_step(step)
      raise InvalidStep unless step.in?(Wizard::Investment::STEPS)
      "Wizard::Investment::#{step.camelize}".constantize.new(session[:investment_attributes])
    end
end
