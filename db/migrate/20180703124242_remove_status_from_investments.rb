class RemoveStatusFromInvestments < ActiveRecord::Migration[5.2]
  def change
    remove_column :investments, :status, :boolean
  end
end
