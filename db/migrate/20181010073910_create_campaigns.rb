class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :affiliates_count
      t.decimal :earnings
      t.string :url

      t.timestamps
    end
  end
end
