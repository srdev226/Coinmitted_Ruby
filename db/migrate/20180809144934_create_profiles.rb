class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :bio
      t.integer :gender
      t.string :language
      t.string :currency
      t.string :country
      t.string :member
      t.boolean :notification_news
      t.boolean :notification_deposit
      t.boolean :notification_payout
      t.boolean :notification_alert
      t.boolean :deleted
      t.boolean :wallet_pin_enabled
      t.string :wallet_pin

      t.timestamps
    end
  end
end
