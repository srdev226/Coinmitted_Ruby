class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :wallet, foreign_key: true
      t.string :name
      t.string :ticker
      t.string :address
      t.decimal :amount, precision: 16, scale: 8
      t.integer :flag

      t.timestamps
    end
  end
end
