class AddNameToPayoutFrequencies < ActiveRecord::Migration[5.2]
  def change
    add_column :payout_frequencies, :name, :string
  end
end
