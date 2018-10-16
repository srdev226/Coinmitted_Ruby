class CreateWalletCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_currencies do |t|
      t.string :name
      t.string :ticker
      t.references :wallet, foreign_key: true
      t.decimal :amount, precision: 16, scale: 8, default: 0.0

      t.timestamps
    end
  end
end
