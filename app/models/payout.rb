class Payout < ApplicationRecord
  belongs_to :user
  belongs_to :investment

  enum status: [:open, :paid]

  before_create :set_reference_number

  def set_reference_number
    self.reference_number = generate_reference
  end

  def generate_reference
    loop do
      token = SecureRandom.hex(3).upcase
      break token unless Payout.where(reference_number: token).exists?
    end
  end
  

end
