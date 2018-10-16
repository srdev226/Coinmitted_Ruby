class AddStatusToSavedInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :saved_investments, :status, :integer, default: 1
  end
end
