class Users::Investments < ApplicationRecord
  belongs_to :user
  has_one :affiliation
end
