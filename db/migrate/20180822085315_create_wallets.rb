class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.references :user, foreign_key: true
      t.decimal :total_in_usd, precision: 8, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
