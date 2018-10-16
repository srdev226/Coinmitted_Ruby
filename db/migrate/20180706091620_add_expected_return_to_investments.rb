class AddExpectedReturnToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :investments, :expected_return, :decimal, precision: 8, scale: 2, default: 0
  end
end
