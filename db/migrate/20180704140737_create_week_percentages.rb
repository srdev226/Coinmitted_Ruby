class CreateWeekPercentages < ActiveRecord::Migration[5.2]
  def change
    create_table :week_percentages do |t|
      t.date :first_date
      t.date :last_date
      t.decimal :percentage, precision: 8, scale: 2

      t.timestamps
    end
  end
end
