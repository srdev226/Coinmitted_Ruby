class AddAffiliateIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :affiliate_id, :integer
    add_index :users, :affiliate_id
  end
end
