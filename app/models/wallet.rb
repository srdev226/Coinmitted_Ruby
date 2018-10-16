class Wallet < ApplicationRecord
  belongs_to :user
  has_many :transactions
  has_many :currencies, class_name: "WalletCurrency"
end
