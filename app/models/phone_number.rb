class PhoneNumber < ApplicationRecord
  belongs_to :profile

  before_save :cleanup_number
  before_save :encrypt_code
  validates :number, presence: true
  validates :full_number, presence: true

  def hidden_number
    if self.number
      number = self.number
      result = []
      number.reverse.split('').each_with_index do |v,i|
        if i.in?([2,3,4,5])
          result << v.sub(v,'x')
        else
          result << v
        end
      end
      result.reverse.join
    end
  end

  def cleanup_number
    self.number.tr!('^0-9', '')
  end

  def encrypt_code
    #self.verification_code = EncryptorService::encrypt(self.verification_code)
  end

  def decrypt_code
    EncryptorService::decrypt(self.verification_code)
  end
  
  def send_otp
    code = 5.times.map { rand(1..9) }.join
    self.update(verification_code: code)
    
    client = Twilio::REST::Client.new
    client.api.account.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: self.full_number,
      body: "Coinmitted verification code: #{code}"
    )    
  end

end
