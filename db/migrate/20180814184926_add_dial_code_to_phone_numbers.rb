class AddDialCodeToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :dial_code, :string
    add_column :phone_numbers, :full_number, :string
  end
end
