class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.string :api_token
      t.string :uuid
      t.string :os
      t.string :os_version
      t.string :device_model
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
