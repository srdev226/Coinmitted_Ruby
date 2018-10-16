module Wizard
  module Investment
    STEPS = %w(index start name timeframe payout amount payment review).freeze
    AMOUNT_PLAN = {basic: 1000.00, blue: 10000.00, vip: 50000.00}

    class Base
      include ActiveModel::Model
      attr_accessor :investment

      delegate *::Investment.attribute_names.map { |attr| [attr, "#{attr}="] }.flatten, to: :investment

      def initialize(investment_attributes)
        @investment = ::Investment.new(investment_attributes)
      end

    end

    class Index < Base
    end

    class Start < Index
    end

    #class Plan < Start
      #validates :investment_plan_id, presence: true
    #end

    class Name < Start
      validates :name, presence: true
    end

    class Timeframe < Name
      include ActiveModel::Validations::Callbacks
      before_validation :set_dates
      validates :end_date, presence: true
      validates :open_date, presence: true

      private
      def set_dates
        #self.end_date = Time.now.months_since(timeframe)
      end
    end

    class Payout < Timeframe
      validates :payout_frequency_id, presence: true
    end

    class Amount < Payout
      attr_accessor :rate
      validates :invested_amount, presence: true
      #validates :invested_amount, presence: true,
        #numericality: {
          #greater_than_or_equal_to: :amount_plan_min,
          #less_than_or_equal_to: :amount_plan_max,
          #only_integer: false,
          #message: ->(object, data) do
            #"investment amount must be within #{object.amount_plan_min} to #{object.amount_plan_max} (depending on the plan, or you can upgrade the investment plan"
          #end
        #}

      def amount_plan_max
        amount = Wizard::Investment::AMOUNT_PLAN[self.investment.investment_plan.title.downcase.to_sym]
        amount_incurrency(amount).round(2)
      end
      def amount_plan_min
        #min_index = 50.00
        #Wizard::Investment::AMOUNT_PLAN.keys.each_with_index {|k,i| min_index = i - 1 if self.investment.investment_plan.title.downcase.to_sym === k }

        #if min_index === -1
          #return amount_incurrency(50.00).round(2)
        #else
          #amount = Wizard::Investment::AMOUNT_PLAN[Wizard::Investment::AMOUNT_PLAN.keys[min_index]]
          #amount_incurrency(amount).round(2)
          #binding.pry
        #end
      end

      def amount_incurrency(amount)
        rate = set_rate
        amount * rate
      end

      def set_rate
        @rate ||= Currency::Converter.new('usd',self.currency).get_rate
      end
    end

    class Payment < Amount
      validates :payment_method_id, presence: true
    end

    class Review < Payment
    end

  end
end
