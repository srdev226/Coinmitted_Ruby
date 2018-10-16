class CreatePayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :payouts do |t|
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.string :reference_number, unique: true
      t.date :pay_date
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.references :investment, foreign_key: true

      t.timestamps
    end

    add_index :payouts, :reference_number, unique: true
  end
end
