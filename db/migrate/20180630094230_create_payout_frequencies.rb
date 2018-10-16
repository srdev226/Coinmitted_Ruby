class CreatePayoutFrequencies < ActiveRecord::Migration[5.2]
  def change
    create_table :payout_frequencies do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :promo

      t.timestamps
    end
  end
end
