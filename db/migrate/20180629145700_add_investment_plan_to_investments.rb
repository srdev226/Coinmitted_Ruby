class AddInvestmentPlanToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_reference :investments, :investment_plan, foreign_key: true
  end
end
