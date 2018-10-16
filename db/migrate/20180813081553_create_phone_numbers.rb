class CreatePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.string :number
      t.boolean :verified
      t.references :profile, foreign_key: true
      t.boolean :default
      t.boolean :deleted

      t.timestamps
    end
  end
end
