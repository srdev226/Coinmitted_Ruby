class AddTimeframeToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :investments, :timeframe, :integer
  end
end
