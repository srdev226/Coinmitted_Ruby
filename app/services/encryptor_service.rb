class EncryptorService

  def self.encrypt(str)
    encryptor.encrypt_and_sign(str)
  end

  def self.decrypt(token)
    encryptor.decrypt_and_verify(token)
  end

  private

  def self.encryptor
    key = ActiveSupport::KeyGenerator.new(
      Rails.application.credentials.encryptor_pass
    ).generate_key(Rails.application.credentials.encryptor_salt, 32)
    ActiveSupport::MessageEncryptor.new(key)
  end

end
