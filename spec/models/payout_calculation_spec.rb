require "rails_helper"

RSpec.describe PayoutCalculation, type: :model do

    before :each do
      WeekPercentage.create(
        first_date: Date.parse("2018-06-25"),
        last_date: Date.parse("2018-07-01"),
        percentage: 5, date: Date.parse("2018-07-01")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-07-02"),
        last_date: Date.parse("2018-07-08"),
        percentage: 5, date: Date.parse("2018-07-08")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-07-09"),
        last_date: Date.parse("2018-07-15"),
        percentage: 5, date: Date.parse("2018-07-15")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-07-16"),
        last_date: Date.parse("2018-07-22"),
        percentage: 5, date: Date.parse("2018-07-22")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-07-23"),
        last_date: Date.parse("2018-07-29"),
        percentage: 5, date: Date.parse("2018-07-29")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-07-30"),
        last_date: Date.parse("2018-08-05"),
        percentage: 5, date: Date.parse("2018-08-05")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-08-06"),
        last_date: Date.parse("2018-08-12"),
        percentage: 5, date: Date.parse("2018-08-12")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-08-13"),
        last_date: Date.parse("2018-08-19"),
        percentage: 5, date: Date.parse("2018-08-19")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-08-20"),
        last_date: Date.parse("2018-08-26"),
        percentage: 5, date: Date.parse("2018-08-26")
      )
      WeekPercentage.create(
        first_date: Date.parse("2018-08-27"),
        last_date: Date.parse("2018-09-02"),
        percentage: 5, date: Date.parse("2018-09-02")
      )
    end

  describe "WEEKLY in Beginning on month Payouts" do
    let(:payout) { FactoryBot.create(:payout,
                   pay_date: Date.parse("2018-07-23"),
                   investment_id: FactoryBot.create(:investment,
                                  open_date: Date.parse("2018-07-18"),
                                  end_date: Date.parse("2018-08-18"),
                                  invested_amount: 900
                                ).id
                ) }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "detects payout frequecy WEEKLY, MONTHLY, etc and not to be NIL" do
      expect(payout_calculation).not_to be_nil
      expect(payout_calculation.frequency).to be_kind_of(String)
    end

    it "return correct payout frequency and calcualte it" do
      #expect(payout_calculation.calculate).to eq "weekly"
    end

    it "set_amount for weekly payouts if invested_amount 900" do
      payout_calculation.weekly_payouts
      expect(payout.amount.to_f).to eq 25.74
    end
  end # weekly at beginning of month payouts

  describe "WEEKLY in End of month Payouts" do
    let(:payout) { FactoryBot.create(:payout,
                   pay_date: Date.parse("2018-07-23"),
                   investment_id: FactoryBot.create(:investment,
                                  open_date: Date.parse("2018-06-19"),
                                  end_date: Date.parse("2018-07-19"),
                                  invested_amount: 900
                                ).id
                ) }
    let(:payout_calculation) { PayoutCalculation.new(payout) }
    it "set_amount for weekly payouts if invested_amount 900" do
      payout_calculation.weekly_payouts
      expect(payout.amount.to_f).to eq 25.74
    end
  end # weekly payouts end of month
  describe "WEEKLY in MID of month Payouts" do
    let(:payout) { FactoryBot.create(:payout,
                   pay_date: Date.parse("2018-07-23"),
                   investment_id: FactoryBot.create(:investment,
                                  open_date: Date.parse("2018-06-25"),
                                  end_date: Date.parse("2018-07-25"),
                                  invested_amount: 900
                                ).id
                ) }
    let(:payout_calculation) { PayoutCalculation.new(payout) }
    it "set_amount for weekly payouts if invested_amount 900" do
      payout_calculation.weekly_payouts
      expect(payout.amount.to_f).to eq 45.0
    end
  end # weekly payouts mid of month


  describe "TWICE a week payouts at beginning" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-08-01"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-19"),
          end_date: Date.parse("2018-08-19"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                               title: "twice",
                                               name: "twice").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "expect not to be nil" do
      expect(payout_calculation.twice_payouts).not_to be_nil
    end
    it "calculate twice" do
      payout_calculation.twice_payouts
      expect(payout.amount.to_f).to eq 64.26
    end
  end # end twice a week

  describe "TWICE a week payouts at mid" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-08-15"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-19"),
          end_date: Date.parse("2018-08-19"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                               title: "twice",
                                               name: "twice").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "expect not to be nil" do
      expect(payout_calculation.twice_payouts).not_to be_nil
    end
    it "calculate twice" do
      payout_calculation.twice_payouts
      expect(payout.amount.to_f).to eq 90.00
    end
  end # end twice a week at mid

  describe "TWICE a week payouts at end" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-09-01"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-19"),
          end_date: Date.parse("2018-08-19"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                               title: "twice",
                                               name: "twice").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "calculate twice" do
      payout_calculation.twice_payouts
      expect(payout.amount.to_f).to eq 45.00
    end
  end # end twice a week at end


  describe "MONTHLY payouts at beginning" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-08-01"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-19"),
          end_date: Date.parse("2018-08-19"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                               title: "monthly",
                                               name: "monthly").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "calculate monthly at beginning" do
      payout_calculation.monthly_payouts
      expect(payout.amount.to_f).to eq 64.26
    end
  end # end monthly at beginning

  describe "MONTHLY payouts at end" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-09-01"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-19"),
          end_date: Date.parse("2018-08-19"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                               title: "monthly",
                                               name: "monthly").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "calculate monthy end of month" do
      payout_calculation.monthly_payouts
      expect(payout.amount.to_f).to eq 135.0
    end
  end # end monthly at end

  describe "end of period payouts" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-08-20"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-20"),
          end_date: Date.parse("2018-08-20"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                                 title: "end_of_period",
                                                 name: "end_of_period").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "calculate end of period" do
      payout_calculation.end_of_period_payouts
      expect(payout.amount.to_f).to eq 237.87
    end
  end # end monthly

  describe "END of PERIOD" do
    let(:payout) {
      FactoryBot.create(:payout,
        pay_date: Date.parse("2018-08-20"),
        investment_id: FactoryBot.create(:investment,
          open_date: Date.parse("2018-07-20"),
          end_date: Date.parse("2018-08-20"),
          invested_amount: 900,
          payout_frequency_id: FactoryBot.create(:payout_frequency,
                                                 title: "end_of_period",
                                                 name: "end_of_period").id
        ).id
      )
    }
    let(:payout_calculation) { PayoutCalculation.new(payout) }

    it "run calculate method" do
      payout_calculation.calculate
      expect(payout.amount.to_f).to eq 237.87
    end
  end # end monthly

end
