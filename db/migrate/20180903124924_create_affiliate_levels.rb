class CreateAffiliateLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliate_levels do |t|
      t.integer :name, default: 0, null: false
      t.integer :range_start
      t.integer :range_end

      t.timestamps
    end
  end
end
