class RemoveStatusFromSavedInvestments < ActiveRecord::Migration[5.2]
  def change
    remove_column :saved_investments, :status, :string
  end
end
