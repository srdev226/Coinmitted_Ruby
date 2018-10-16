class AddEarnedToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :investments, :earned, :decimal, precision: 8, scale: 2
  end
end
