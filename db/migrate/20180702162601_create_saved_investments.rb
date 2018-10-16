class CreateSavedInvestments < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_investments do |t|
      t.references :user, foreign_key: true
      t.string :name, :null => true
      t.string :invested_amount, :null => true
      t.string :status, :null => true
      t.datetime :open_date, :null => true
      t.datetime :end_date, :null => true
      t.integer :investment_plan_id, :null => true
      t.integer :payout_frequency_id, :null => true
      t.integer :payment_method_id, :null => true
      t.integer :timeframe, :null => true

      t.timestamps
    end
  end
end
