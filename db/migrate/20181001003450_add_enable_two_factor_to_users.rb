class AddEnableTwoFactorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :enable_two_factor, :boolean, default: false
  end
end
