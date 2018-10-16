class AddMaxAndMinToInvestmentPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :investment_plans, :min, :decimal, precision: 10, scale: 2
    add_column :investment_plans, :max, :decimal, precision: 10, scale: 2
  end
end
