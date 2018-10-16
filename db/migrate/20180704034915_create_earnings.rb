class CreateEarnings < ActiveRecord::Migration[5.2]
  def change
    create_table :earnings do |t|
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.references :investment, foreign_key: true

      t.timestamps
    end
  end
end
