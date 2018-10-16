require 'rails_helper'

RSpec.describe WalletHelper, type: :helper do

  before :each do
    @user = create(:user)
    @wallet = create(:wallet, user_id: @user.id)
    create(:profile, user_id: @user.id)
    create(:investment,user_id: @user.id, invested_amount: 100, currency: "USD")
    create(:wallet_currency, ticker: "BTC", wallet_id: @wallet.id, amount: 1.0)
    create(:wallet_currency, ticker: "LTC", wallet_id: @wallet.id, amount: 1.0)
    create(:wallet_currency, ticker: "ETH", wallet_id: @wallet.id, amount: 1.0)
    Rate.create(from: "BTC", to: "USD", rate: 10000, old_rate: 10050)
    Rate.create(from: "LTC", to: "USD", rate: 500, old_rate: 505)
    Rate.create(from: "ETH", to: "USD", rate: 1000, old_rate: 999)
  end

  describe "calculations" do
    it "show wallet total balance" do
      result = wallet_total_balance(@wallet.currencies, 'USD')
      expect(result).to eq 11500.0
    end

    it "show rate difference of crypto" do
      result = CryptoConverter.new("USD", "BTC", 1.0).rate_difference
      expect(result).to eq 0.5
    end

    it "show rate difference with decorator" do
      result = rate_difference("USD","BTC")
      expect(result).to be_kind_of(String)
    end

    it "show total user deposit" do
      result = total_user_deposit(@user)
      expect(result).to eq 100
    end

    it "show total user withdrawal" do
      @wallet.transactions.create(ticker: "BTC", amount: 0.1)
      result = total_user_withdrawal(@wallet)
      expect(result).to eq 1000
    end

    it "show user pending withdrawal" do
      @wallet.transactions.create(ticker: "BTC", amount: 0.2)
      result = total_user_pending_withdrawal(@wallet)
      expect(result).to eq 2000
    end

    it "show total user balance of profile" do
      result = total_user_balance(@user)
      expect(result).to eq 100
    end

  end
end
