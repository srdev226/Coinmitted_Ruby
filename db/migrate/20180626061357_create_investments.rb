class CreateInvestments < ActiveRecord::Migration[5.2]
  def change
    create_table :investments do |t|
      t.string :name
      t.decimal :invested_amount, precision: 8, scale: 2
      t.boolean :status
      t.datetime :open_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
