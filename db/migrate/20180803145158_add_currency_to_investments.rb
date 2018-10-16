class AddCurrencyToInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :investments, :currency, :string
  end
end
