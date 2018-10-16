class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.string :from
      t.string :to
      t.decimal :rate, precision: 26, scale: 16
      #t.decimal :old_rate, precision: 26, scale: 16, default: 0.0

      t.timestamps
    end
  end
end
