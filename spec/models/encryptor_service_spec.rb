require "rails_helper"

RSpec.describe EncryptorService, type: :model do

  describe "Encryptor Service" do

    it "should encrypt mesage" do
      m = EncryptorService::encrypt("1234")
      expect(m).to be_kind_of(String)
      expect( m ).not_to eq '1234'
    end
    it "should decrypt mesage" do
      m = EncryptorService::encrypt("1234")
      expect(EncryptorService::decrypt(m)).to eq '1234'
    end
  end

end
