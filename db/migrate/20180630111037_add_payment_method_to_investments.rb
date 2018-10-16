class AddPaymentMethodToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_reference :investments, :payment_method, foreign_key: true
  end
end
