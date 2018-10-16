class Investment < ApplicationRecord
  belongs_to :user
  belongs_to :investment_plan, optional: true
  belongs_to :payout_frequency, optional: true
  belongs_to :payment_method, optional: true
  has_many :earnings, dependent: :destroy
  has_many :payouts, :dependent => :delete_all
  has_many :payments, dependent: :destroy

  attr_accessor :skip_validation
  attr_accessor :admin_edit_user

  #validates :investment_plan_id, presence: true, unless: :skip_validation
  #validates :name, presence: true, unless: :skip_validation
  #validates :timeframe, presence: true, unless: :skip_validation
  #validates :end_date, presence: true, unless: :skip_validation
  #validates :open_date, presence: true, unless: :skip_validation
  #validates :payout_frequency_id, presence: true, unless: :skip_validation
  #validates :payment_method_id, presence: true, unless: :skip_validation
  #validates :invested_amount, presence: true,
    #numericality: {
    #greater_than_or_equal_to: :amount_plan_min,
      #less_than_or_equal_to: :amount_plan_max,
      #only_integer: false,
      #message: ->(object, data) do
        #"investment amount must be within #{object.amount_plan_min} to #{object.amount_plan_max} (depending on the plan, or you can upgrade the investment plan"
      #end
    #}, unless: :skip_validation

  #before_destroy :check_if_can_be_destroyed

  # Active = active investment, Draft = saved investment, Ended = fully paid, Payment = waiting for payment
  enum status: [:active, :draft, :ended, :payment]

  #def check_if_can_be_destroyed
    #binding.pry
    #if self.end_date > Date.today
      #errors.add(:base, "You can't delete this Investment untill it will be finished")
      #throw :abort
    #end
  #end

  def timeframe_months
    if self.end_date.present?
    number = (self.end_date.year * 12 + self.end_date.month) - (Date.today.year * 12 + Date.today.month)
    else
      number = 0
    end
    "#{number} #{'month'.pluralize(number).capitalize}"
  end

  def plan_name
    "#{self.investment_plan.title} #{self.investment_plan.subtitle}"
  end

  def amount_plan_max
    amount = Wizard::Investment::AMOUNT_PLAN[self.investment_plan.title.downcase.to_sym]
    amount_incurrency(amount).round(2)
  end

  def amount_plan_min
    min_index = 50.00
    Wizard::Investment::AMOUNT_PLAN.keys.each_with_index {|k,i| min_index = i - 1 if self.investment_plan.title.downcase.to_sym === k }

    if min_index === -1
      return amount_incurrency(50.00).round(2)
    else
      amount = Wizard::Investment::AMOUNT_PLAN[Wizard::Investment::AMOUNT_PLAN.keys[min_index]]
      amount_incurrency(amount).round(8)
    end
  end

  def amount_incurrency(amount)
    rate = get_rate
    amount * rate
  end

  def get_rate
    @rate ||= Currency::Converter.new('usd',self.currency).get_rate
  end
  
  def payout_earnings
    payouts.map(&:amount).sum
  end
  
  def profit_percentage
    (self.payout_earnings / self.invested_amount) * 100
  end

end
