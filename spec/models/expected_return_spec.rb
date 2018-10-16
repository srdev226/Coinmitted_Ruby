require "rails_helper"

RSpec.describe ExpectedReturn, type: :model do

  let!(:user) { FactoryBot.create(:user) }
  let(:expected_return) { ExpectedReturn.new( FactoryBot.create(:investment), "weekly", user ) }
  before :each do
    PayoutFrequency.create(
      name: "weekly",
      title: "Weekly",
    )
    PayoutFrequency.create(
      name: "twice",
      title: "Twice a month",
    )
    PayoutFrequency.create(
      name: "monthly",
      title: "Monthly",
    )
    PayoutFrequency.create(
      name: "end_of_period",
      title: "End of period",
    )

    36.times { |n|
      date = Date.parse("2018-01-04")
      date += n * 7
      WeekPercentage.create(
        first_date: date.at_beginning_of_week,
        last_date: date.at_end_of_week,
        date: date.at_beginning_of_week,
        percentage: 10
      )
    }
  end


  describe "expected_return weeks" do

    it "should not be nil" do
      expect(expected_return.prev_weeks).not_to be nil
    end

    it "show number of weeks to calcualte" do
      pf = PayoutFrequency.where(name: "weekly").first
      expected_return.wizard_investment["payout_frequency_id"] = pf.id
      expect(expected_return.payout_frequency).to eq 4
    end

    it "return total_percentage" do
      pf = PayoutFrequency.where(name: "weekly").first
      expected_return.wizard_investment["payout_frequency_id"] = pf.id
      expect(expected_return.total_percentage.round(3)).to eq 42.857
    end

    it "return total_percentage depends on the month" do
      pf = PayoutFrequency.where(name: "weekly").first
      expected_return.wizard_investment["payout_frequency_id"] = pf.id
      expected_return.wizard_investment["timeframe"] = 10
      expect(expected_return.total_percentage.round(3)).to eq 42.857
    end

    it "return total" do
      pf = PayoutFrequency.where(name: "weekly").first
      expected_return.wizard_investment["payout_frequency_id"] = pf.id
      expected_return.wizard_investment["invested_amount"] = 1000
      expected_return.wizard_investment["timeframe"] = 1
      expect(expected_return.amount.round(2).to_f).to eq 1428.57
    end

    it "return total for twice a week" do
      pf = PayoutFrequency.where(name: "twice").first
      expected_return =  ExpectedReturn.new( FactoryBot.create(:investment,
                                              payout_frequency_id: pf.id,
                                              invested_amount: 1000,
                                              timeframe: 2
                                             ), "twice", user )
      expect(expected_return.amount.round(2).to_f).to eq 1871.43
    end

    it "return total 3 month timeframe" do
      pf = PayoutFrequency.where(name: "monthly").first
      expected_return =  ExpectedReturn.new( FactoryBot.create(:investment,
                                              payout_frequency_id: pf.id,
                                              invested_amount: 1000,
                                              timeframe: 3
                                             ), "monthly" , user)
      expect(expected_return.amount.round(2).to_f).to eq 2300.0
    end

    it "return total 3 month timeframe and end of period" do
      pf = PayoutFrequency.where(name: "end_of_period").first
      expected_return =  ExpectedReturn.new( FactoryBot.create(:investment,
                                              payout_frequency_id: pf.id,
                                              invested_amount: 1000,
                                              timeframe: 3
                                             ), "end_of_period", user )
      expect(expected_return.amount.round(2).to_f).to eq 2350.0
    end

    it "return total earning of investing" do
      pf = PayoutFrequency.where(name: "weekly").first
      expected_return =  ExpectedReturn.new( FactoryBot.create(:investment,
                                              payout_frequency_id: pf.id,
                                              invested_amount: 1000,
                                              timeframe: 1
                                             ), "weekly", user )
      expect(expected_return.total_earnings.round(2).to_f).to eq 428.57
    end

    it "return total earning of investing with 5% of end_of_investment" do
      pf = PayoutFrequency.where(name: "end_of_period").first
      expected_return =  ExpectedReturn.new( FactoryBot.create(:investment,
                                              payout_frequency_id: pf.id,
                                              invested_amount: 1000,
                                              timeframe: 1
                                             ), "end_of_period", user )
      expect(expected_return.total_earnings.round(2).to_f).to eq 478.57
    end
  end
end
