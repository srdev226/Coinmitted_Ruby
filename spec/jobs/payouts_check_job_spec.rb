require 'rails_helper'

RSpec.describe PayoutsCheckJob, type: :job do
  describe "Payout Calculation" do
    before :each do
      WeekPercentage.create(
        first_date: Date.today.beginning_of_week,
        last_date: Date.today.end_of_week,
        percentage: 5, date: Date.today.end_of_week
      )
      WeekPercentage.create(
        first_date: Date.today.beginning_of_week - 7.day,
        last_date: Date.today.end_of_week - 7.day,
        percentage: 5, date: Date.today.end_of_week - 7.day
      )
      FactoryBot.create(:payout,
                         pay_date: Date.today
                      )

    end

    it "calculate payouts" do
      ActiveJob::Base.queue_adapter = :test
      PayoutsCheckJob.perform_now
      expect(Payout.where(pay_date: Date.today).first.amount).to be > 0
    end
  end
end
