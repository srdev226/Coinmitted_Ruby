class AddVerificationCodeToPhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :phone_numbers, :verification_code, :string
  end
end
