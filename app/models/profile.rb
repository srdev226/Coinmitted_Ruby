class Profile < ApplicationRecord
  belongs_to :user
  has_many :phone_numbers, dependent: :destroy

  has_one_attached :avatar
  enum gender: [:male, :female, :other]
  enum membership: [:Basic, :Premium, :VIP]

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :phone_numbers

  validates :name, presence: true

  attr_accessor :generate_pin # checkeck if new pin params are exist
  attr_accessor :admin_edit_user # true if admin edit user's profile

  before_save :set_encrypted_pin, if: :generate_pin

  MEMBER = {50..999 => "Basic", 1000..9999 => "Blue", 10000..Float::INFINITY => "VIP"}.freeze

  # from country select gem
  def country_name
    if self.country
      country = ISO3166::Country[self.country]
      country.translations[I18n.locale.to_s] || country.name
    else
      self.country
    end
  end

  def set_encrypted_pin
    if self.wallet_pin_enabled
      self.wallet_pin = EncryptorService::encrypt(self.wallet_pin)
    else
      self.wallet_pin = ''
    end
  end

  def member
    amount = 0
    self.user.investments.each do |item|
      if item.status == 'active' || item.status == 'ended'
        rate = Currency::Converter.new(item.currency.upcase,'USD').get_rate
        amount += item.invested_amount.to_f * rate.to_f
      end
    end
    if amount < 49
      "Basic"
    else
      MEMBER.select {|n| n === amount }.values.first
    end
  end
end
