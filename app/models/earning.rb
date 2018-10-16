class Earning < ApplicationRecord
  belongs_to :user
  belongs_to :investment

  validates :user_id, presence: true
  validates :investment_id, presence: true
end
