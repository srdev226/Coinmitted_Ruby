class AddStatusToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :investments, :status, :integer, default: 1
  end
end
