class CreateUsersInvestments < ActiveRecord::Migration[5.2]
  def change
    create_table :users_investments do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.references :user, foreign_key: true
      t.integer :affiliate_id, foreign_key: true

      t.timestamps
    end
  end
end
