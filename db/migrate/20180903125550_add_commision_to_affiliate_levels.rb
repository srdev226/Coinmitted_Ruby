class AddCommisionToAffiliateLevels < ActiveRecord::Migration[5.2]
  def change
    add_column :affiliate_levels, :commision, :decimal, default: 0
  end
end
