class Device < ApplicationRecord
  belongs_to :user

  validates_presence_of :uuid

  before_create :set_secured_token

  def set_secured_token
    begin
      self.api_token = SecureRandom.hex(64)
    end while self.class.exists?(api_token: api_token)
  end
end
