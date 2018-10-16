class CreateInvestmentPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :investment_plans do |t|
      t.string :title
      t.string :subtitle
      t.text :description

      t.timestamps
    end
  end
end
