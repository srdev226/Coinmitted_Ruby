class Transaction < ApplicationRecord
  belongs_to :wallet
  validates :address, presence: true
  validates :amount, presence: true
  after_initialize :set_default_flag, :if => :new_record?

  default_scope { order(created_at: :desc) }

  enum flag: [:pending, :completed]

  def set_default_flag
    self.flag ||= :pending
  end
end
