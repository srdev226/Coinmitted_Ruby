require 'rails_helper'

RSpec.describe PayoutGenerator, type: :model do

  describe "Generate payouts" do

    let(:payout_generator) {
      PayoutGenerator.new(
        FactoryBot.create(:investment)
      )
    }

    it "should not be nil" do
      expect(payout_generator).not_to be_nil
    end
  end

  describe "Generate correct amount of WEEKLY Payouts" do

    describe "Create 6 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-20"),
                            end_date: Date.parse("2018-08-20"),
                            timeframe: 1
                           )
        )
      }

      it "should genetare 6 payments" do
        payout_generator.generate_weekly_payouts
        expect(Payout.all.count).to eq 6
      end
    end

    describe "Create 5 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-19"),
                            end_date: Date.parse("2018-08-19"),
                            timeframe: 1
                           )
        )
      }

      it "should genetare 5 payments" do
        payout_generator.generate_weekly_payouts
        expect(Payout.all.count).to eq 5
      end
    end

    describe "Create 6 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-21"),
                            end_date: Date.parse("2018-08-21"),
                            timeframe: 1
                           )
        )
      }

      it "should genetare 6 payments" do
        payout_generator.generate_weekly_payouts
        expect(Payout.all.count).to eq 6
      end
    end

    describe "Create 10 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-21"),
                            end_date: Date.parse("2018-09-21"),
                            timeframe: 2
                           )
        )
      }

      it "should genetare 10 payments" do
        payout_generator.generate_weekly_payouts
        expect(Payout.all.count).to eq 10
      end
    end

  end # End of WEEKLY

  describe "Generate correct amount of TWICE Payouts" do
    describe "Create 3 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-19"),
                            end_date: Date.parse("2018-08-19"),
                            timeframe: 1
                           )
        )
      }

      it "should crate array of payment dates" do
        expect(payout_generator.send(:twice_a_month_schedule, Date.parse("2018-07-19"),Date.parse("2018-08-19")).count).to eq 3
        expect(payout_generator.send(:twice_a_month_schedule, Date.parse("2018-07-15"),Date.parse("2018-08-15")).count).to eq 3
        expect(payout_generator.send(:twice_a_month_schedule, Date.parse("2018-07-20"),Date.parse("2018-09-20")).count).to eq 5
      end
      it "should genetare 3 payments" do
        payout_generator.generate_twice_payouts
        expect(Payout.all.count).to eq 3
      end
    end
    describe "Create 3 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-19"),
                            end_date: Date.parse("2018-09-19"),
                            timeframe: 2
                           )
        )
      }

      it "should crate array of payment dates" do
        expect(payout_generator.send(:twice_a_month_schedule, Date.parse("2018-07-19"),Date.parse("2018-08-19")).count).to eq 3
        expect(payout_generator.send(:twice_a_month_schedule, Date.parse("2018-07-15"),Date.parse("2018-08-15")).count).to eq 3
        expect(payout_generator.send(:twice_a_month_schedule, Date.parse("2018-07-20"),Date.parse("2018-09-20")).count).to eq 5
      end
      it "should genetare 5 payments" do
        payout_generator.generate_twice_payouts
        expect(Payout.all.count).to eq 5
      end
    end
  end # End of TWICE

  describe "Generate correct amount of MONTHLY Payouts" do

    describe "Create 1 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-19"),
                            end_date: Date.parse("2018-08-19"),
                            timeframe: 1
                           )
        )
      }

      it "should genetare 1 payments" do
        payout_generator.generate_monthly_payouts
        expect(Payout.all.count).to eq 1
      end
    end

    describe "Create 2 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-19"),
                            end_date: Date.parse("2018-09-19"),
                            timeframe: 2
                           )
        )
      }

      it "should genetare 2 payments" do
        payout_generator.generate_monthly_payouts
        expect(Payout.all.count).to eq 2
      end
    end

    describe "Create 2 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-01"),
                            end_date: Date.parse("2018-09-01"),
                            timeframe: 2
                           )
        )
      }

      it "should genetare 2 payments" do
        payout_generator.generate_monthly_payouts
        expect(Payout.all.count).to eq 2
      end
    end

  end # End of MONTHLY

  describe "Generate correct amount of END OF PERIOD Payouts" do

    describe "Create 1 Payouts" do
      let(:payout_generator) {
        PayoutGenerator.new(
          FactoryBot.create(:investment,
                            open_date: Date.parse("2018-07-19"),
                            end_date: Date.parse("2018-08-19"),
                            timeframe: 1
                           )
        )
      }

      it "should genetare 1 payments" do
        payout_generator.generate_end_of_period_payouts
        expect(Payout.all.count).to eq 1
      end
    end

  end # End of period

  describe "Weekly Payout" do
    let(:payout) { FactoryBot.create(:payout) }

    let(:payout_generator) {
      PayoutGenerator.new(
        FactoryBot.create(:investment,
                          open_date: Date.parse("2018-07-20"),
                          end_date: Date.parse("2018-08-20"),
                          timeframe: 1
                         )
      )
    }
    it "payout shouldn't be nil" do
      expect(payout).not_to be_nil
    end

    it "calculate weekly payout" do
      #payout_generator.weekly_payout
      #expect(payout).to eq 1
    end

  end


end
