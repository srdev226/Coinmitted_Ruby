class WizardInvestmentsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  before_action :load_investment_wizard, except: %i(validate_step cancel ready continue pay)
  before_action :set_investment_plans
  before_action :set_payout_frequency
  before_action :set_payment_method

  def validate_step
    current_step = params[:current_step]


    @investment_wizard = wizard_investment_for_step(current_step)
    @investment_wizard.investment.attributes = investment_wizard_params

    binding.pry
    if @investment_wizard.investment[:user_id].nil?
      @investment_wizard.investment.write_attribute("user_id",current_user.id)
    end

    if current_step == "amount"

      # PLANS HAS BEEN REMOVED
      # Upgrade plan if user invest more money that in plan range
      #amount = params[:investment_wizard][:invested_amount].to_f
      #if amount_incurrency(amount) > @investment_wizard.investment.investment_plan.max
        #new_invested_amount = InvestmentPlan.where("max > ?", amount_incurrency(amount).to_f).first
        #@investment_wizard.investment.write_attribute("investment_plan_id", new_invested_amount.id)
      #end

      # TODO remove associaltion of investment plan in future
      @investment_wizard.investment.write_attribute("investment_plan_id", InvestmentPlan.first.id)
      @investment_wizard.investment.write_attribute("earned", 0.0)

      # invested_attributes, payment_frequency
      expected = ExpectedReturn.new(
        @investment_wizard.investment.attributes,
        @investment_wizard.investment.payout_frequency.name,
        current_user
      )
      #binding.pry

      @investment_wizard.investment.write_attribute("expected_return",expected.amount)
      @investment_wizard.investment.write_attribute("investment_earning",expected.return_25)
      @investment_wizard.investment.write_attribute("currency",@currency.downcase)
    end

    if params[:investment_wizard][:timeframe].present?
      timeframe = params[:investment_wizard][:timeframe].to_i
      @investment_wizard.investment.write_attribute("end_date", Time.now.months_since(timeframe))
    end
    session[:investment_attributes] = @investment_wizard.investment.attributes

    if @investment_wizard.valid?
      next_step = wizard_investment_next_step(current_step)
      create and return unless next_step
      if current_step == "review"
        redirect_to investments_path
      else 
        redirect_to action: next_step
      end
    else
      render current_step
    end

  end

  # Investment status 0 > active, 1 > draft, 2 > ended, 3 > payment
  #
  # If investment already exists in database,
  # then update all attributes with new values
  # else save new investment and generate all payout dates
  # redirect to ready_wizard otherwise redirect with error
  def create
    hash = {}
    if @investment_wizard.investment.id.present?
      invs = Investment.find(@investment_wizard.investment.id)
      @investment_wizard.investment.attributes.each do |attr|
        hash.merge!(attr[0].to_sym => attr[1] ) unless attr[0].in? ['id','created_at','updated_at']
      end

      hash.merge!(:status => 3) # change sttus to wait for payment
      invs.update_attributes(hash)

      generate_payouts(@investment_wizard.investment)

      session[:investment_attributes] = nil
      redirect_to pay_wizard_investment_path(investment: invs.id), notice: "Investment successfully updated"
    else
      if @investment_wizard.investment.save

        generate_payouts(@investment_wizard.investment)

        # Queue job to wait untill finish and change status
        InvestmentStatusCheckJob.set(wait_until: @investment_wizard.investment.end_date + 5.minutes).perform_later(@investment_wizard.investment.id)

        session[:investment_attributes] = nil
        @investment_wizard.investment.update_attributes(:status => 3) # change sttus to wait for payment
        redirect_to pay_wizard_investment_path(investment: @investment_wizard.investment.id), notice: "Investment successfully created"
      else
        redirect_to({action: Wizard::Investment::STEPS.first}, alert: "There were a problem when creating a investment.")
      end
    end

  end

  # Redirect here to continue of saved in draft investment
  # Redirect here to continue of add fund pressed
  def continue
    if params[:add_fund].present?
      session[:investment_attributes] = Investment.find(params[:add_fund]).attributes
      redirect_to amount_wizard_investment_path
    else
      session[:investment_attributes] = Investment.find(params[:draft]).attributes
      redirect_to plan_wizard_investment_path
    end
  end

  # Last step of investment wizard
  def ready
    @investment = Investment.where(user_id: current_user.id).last
  end

  def pay
    begin
      @investment = Investment.find(params[:investment])
    rescue StandardError => e
      redirect_to investments_path, alert: "Error: #{e}"
    end
    #amount = fiat_rate('usd',@investment.payment_method.ticker,@investment.invested_amount)
    #@amount_in_crypto = amount
  end

  # If clicked cancel button, save all values in database
  # skip_validation = true - to be able to skip validations
  # for empty attributes
  def cancel
    investment = Investment.new(session[:investment_attributes])
    investment.skip_validation = true
    investment.status = 1
    if investment.save
      redirect_to investments_path, notice: "Your Investments successfuly saved!"
    else
      redirect_to start_wizard_investment_path, alert: "Something went wrong, your investments hasn't been saved"
    end
  end

  def return_expected_return_value
    expected_return = ExpectedReturn.new(
      @investment_wizard.investment.attributes,
      @investment_wizard.investment.payout_frequency.name,
      current_user
    )
    @investment_wizard.investment.write_attribute("expected_return",expected_return.amount)
  end

  private

  def load_investment_wizard
    @investment_wizard = wizard_investment_for_step(action_name)
  end

  def wizard_investment_next_step(step)
    Wizard::Investment::STEPS[Wizard::Investment::STEPS.index(step) + 1]
  end

  def wizard_investment_for_step(step)
    raise InvalidStep unless step.in?(Wizard::Investment::STEPS)
    "Wizard::Investment::#{step.camelize}".constantize.new(session[:investment_attributes])
  end

  def set_investment_plans
    @investment_plans = InvestmentPlan.all
  end

  def set_payout_frequency
    @payout_frequency = PayoutFrequency.all
  end

  def set_payment_method
    @payment_method = PaymentMethod.all
  end

  def investment_wizard_params
    params.require(:investment_wizard).permit(
      :investment_plan_id, :name, :invested_amount, :status, :open_date, :end_date,
      :user_id, :timeframe, :payout_frequency_id, :payment_method_id, :expected_return,
      :currency
    )
  end

  def amount_incurrency(amount)
    rate = Currency::Converter.new(@currency,'usd').get_rate
    amount * rate
  end

  def set_earnings_weekly_percentage
    #@earnings_weekly_percentage = EarningPercentage.where(name: "weekly").first
  end

  def generate_payouts(investment)

    case investment.payout_frequency.name
    when "weekly"
      PayoutGenerator.new(investment).generate_weekly_payouts
      #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_weekly
    when "twice"
      PayoutGenerator.new(investment).generate_twice_payouts
      #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_twice
    when "monthly"
      PayoutGenerator.new(investment).generate_monthly_payouts
      #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_monthly
    when "end_of_period"
      PayoutGenerator.new(investment).generate_end_of_period_payouts
      #ExpectedReturn.new(investment.attributes, investment.payout_frequency.name, current_user).payout_end_of_period
    end
  end

  class InvalidStep < StandardError; end
end
