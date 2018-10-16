class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :investment, foreign_key: true
      t.string :currencies
      t.string :invoice
      t.integer :confirmations
      t.integer :max_confirmations
      t.string :invoice
      t.boolean :success
      t.string :coin
      t.decimal :coins_received, precision: 27, scale: 18

      t.timestamps
    end
  end
end
