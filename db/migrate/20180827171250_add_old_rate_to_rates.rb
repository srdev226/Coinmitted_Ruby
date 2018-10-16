class AddOldRateToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :old_rate, :decimal, precision: 26, scale: 16, default: 0.0
  end
end
