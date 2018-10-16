require 'rails_helper'

RSpec.describe Payment, type: :model do

  let(:payment) { Payment.new }

  it "test external call" do
    #address = "https://api.paybear.io/v2/eth/payment/payments?token=#{Rails.application.credentials['PAYBEAR_SECRET']}"
    #escaped_address = URI.escape(address)
    #uri = URI.parse(escaped_address)
    #response = Net::HTTP.get(uri)

    stub_request(:get, "https://api.paybear.io/v2/eth/payment/payments?token=").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Host'=>'api.paybear.io',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: "", headers: {})

         #expect(response.status).to eq "200"
  end

  it "show payment address" do
    url = "https://api.paybear.io/v2/btc/payment/https:%2F%2Fcoinmitted.herokuapp.com%2Fpayments%2F%2Fcallback?token=sec7f4517b2c86878f8e9f78969cf95625b"
    status = 200
    body = [
      {
        address: '0x2BccBE033fCBC18f074D20Cc3BC0591742C094DC'
      }
    ].to_json

    stub_request(:get, url).to_return(status: status, body: body)

    #payment.get_address('eth')
    #binding.pry
    #expect(payment.get_address('eth')).to eq "address"
  end
end
