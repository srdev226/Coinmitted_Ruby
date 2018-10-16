class AddSecurityTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :affiliate_token, :string
    add_index :users, :affiliate_token, unique: true
  end
end
