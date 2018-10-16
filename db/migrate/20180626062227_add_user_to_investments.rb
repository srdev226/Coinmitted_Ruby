class AddUserToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_reference :investments, :user, foreign_key: true
  end
end
