class AddMembershipToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :membership, :integer
  end
end
