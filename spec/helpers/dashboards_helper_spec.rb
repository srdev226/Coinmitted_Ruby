require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do

  before :each do
    @user = create(:user)
  end

  describe "calculations" do

    it "total users invested" do
      users = [true,false,false,true,false]
      result = total_users_invested(users, true)
      expect(result).to eq 2
    end

    it "total users not invested" do
      users = [true,false,false,true,false]
      result = total_users_invested(users, false)
      expect(result).to eq 3
    end

    it "return right percentage" do
      data = (1.0 / 7.0) * 100
      expect(data.round(3)).to eq 14.286
    end

    it "return profit of investment" do
      inv = FactoryBot.create(:investment)
      inv.invested_amount = 900
      inv.investment_earning = 99
      expect(profit(inv)).to eq "+11.000%"
    end

    it "show correct day of next payout" do
      # investment should be in collection
      # to test should be added []
      invs = FactoryBot.create(:investment)
      invs.payouts.create(pay_date: Date.today + 3.day, user_id: @user.id)
      expect(next_payout([invs])).to eq Date.today + 3.day
    end

    it "should return current amount of invested" do
      invs = FactoryBot.create(:investment)
      invs.invested_amount = 600
      result = amounts_in_cur_currency([invs], 'invested')
      expect(result).to eq 600
    end

    it "should return current amount of earnings" do
      invs = FactoryBot.create(:investment)
      invs.earned = 600
      result = amounts_in_cur_currency([invs], 'earning')
      expect(result).to eq 600
    end

    context "Week Percentages" do

      before :each do
        WeekPercentage.create(first_date: Date.today, last_date: Date.today + 5.day, percentage: 10.0, date: Date.today)
        WeekPercentage.create(first_date: Date.today + 1.day, last_date: Date.today + 6.day, percentage: 7.0, date: Date.today + 1.day)
      end

      it "return average percentages per week" do
        wp = WeekPercentage.all
        result = average_weekly(wp)
        expect(result).to eq "8.50%"
      end

      it "return last week percentage" do
        wp = WeekPercentage.all
        result = last_week(wp)
        expect(result).to eq "7.00%"
      end

      it "return last month percentage" do
        wp = WeekPercentage.all
        result = last_month(wp)
        expect(result).to eq "8.50%"
      end

      it "return best month percentage" do
        wp = WeekPercentage.all
        result = best_month(wp)
        expect(result).to eq "8.50%"
      end

      it "return worst month percentage" do
        wp = WeekPercentage.all
        result = worst_month(wp)
        expect(result).to eq "8.50%"
      end

      it "return praph month percentage" do
        wp = WeekPercentage.all
        result = graph_month(wp)
        expect(result).to eq [8.5]
      end

    end

    it "return all users balance" do
      Rate.create(from:"RUB",to:"USD",rate: '0.50')
      profile = FactoryBot.create(:profile, user_id: @user.id, balance: 200)
      expect(total_users_balance([@user],'USD')).to eq "200.00"
    end

    it "return total users deposit" do
      Rate.create(from:"RUB",to:"USD",rate: '0.50')
      FactoryBot.create(:investment, user_id: @user.id, invested_amount: 100)
      FactoryBot.create(:investment, user_id: @user.id, invested_amount: 200, currency: "RUB")
      result = total_users_deposit([@user])
      expect(result).to eq "200.00"
    end

    context "Crypto-currency" do
      before :each do
        Payment.create(investment_id: create(:investment).id, success: true, coin: 'btc', coins_received: '0.98764')
        Payment.create(investment_id: create(:investment).id, success: true, coin: 'eth', coins_received: '0.00964')
        Payment.create(investment_id: create(:investment).id, success: true, coin: 'btc', coins_received: '0.00364')
        Payment.create(investment_id: create(:investment).id, success: true, coin: 'ltc', coins_received: '1.98764')
      end

      it "return all input of btc" do
        expect(all_crypto_in('btc').to_f).to eq 0.99128
        expect(all_crypto_in('eth').to_f).to eq 0.00964
        expect(all_crypto_in('ltc').to_f).to eq 1.98764
      end
    end


  end
end
