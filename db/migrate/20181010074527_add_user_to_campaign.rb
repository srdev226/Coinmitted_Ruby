class AddUserToCampaign < ActiveRecord::Migration[5.2]
  def change
    add_reference :campaigns, :user, foreign_key: true
  end
end
