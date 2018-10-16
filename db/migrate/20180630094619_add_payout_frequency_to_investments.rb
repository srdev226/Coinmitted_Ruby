class AddPayoutFrequencyToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_reference :investments, :payout_frequency, foreign_key: true
  end
end
