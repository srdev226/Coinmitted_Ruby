class AddVisitsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :affiliate_link_visits, :integer, default: 0, null: false
  end
end
