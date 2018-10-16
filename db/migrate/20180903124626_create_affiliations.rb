class CreateAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :affiliations do |t|
      t.references :user, foreign_key: true
      t.integer :affiliate_id, foreign_key: true
      t.integer :investment_id, foreign_key: true

      t.timestamps
    end
  end
end
