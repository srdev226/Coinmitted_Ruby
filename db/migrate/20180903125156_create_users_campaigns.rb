class CreateUsersCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :users_campaigns do |t|
      t.string :name
      t.string :referal_token
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :users_campaigns, :referal_token, unique: true
  end
end
