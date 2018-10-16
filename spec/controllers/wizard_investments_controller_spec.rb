require "rails_helper"

RSpec.describe WizardInvestmentsController, type: :controller do

    let!(:user) { FactoryBot.create(:user) }

    let(:valid_attributes) {
      {
        name: "my investment",
        invested_amount: 999,
        open_date: Date.parse("2018-07-05"),
        end_date: Date.parse("2018-08-05"),
        user_id: user.id,
        investment_plan_id: FactoryBot.create(:investment_plan,
                                             title: 'basic'
                                             ).id,
        payout_frequency_id: FactoryBot.create(:payout_frequency,
                                               title: "end_of_period",
                                              name: "end_of_period").id,
        payment_method_id: FactoryBot.create(:payment_method).id,
        timeframe: 1,
        status: 'draft',
        expected_return: 1500,
        earnings: 500,
        currency: "USD"
      }

    }


    before :each do
      36.times { |n|
        date = Date.parse("2018-01-04")
        date += n * 7
        WeekPercentage.create(
          first_date: date.at_beginning_of_week,
          last_date: date.at_end_of_week,
          date: date.at_beginning_of_week,
          percentage: 10 #Random.rand(11) + 1
        )
      }
    end

  describe "POST create" do
    include ActiveJob::TestHelper

    after :each do
      clear_enqueued_jobs
    end

    context "with valid params" do
      it "create a new investment" do
        sign_in user
        expect {
          post :validate_step, params: { investment_wizard: valid_attributes, current_step: "review" }
        }.to change(Investment, :count).by(1)
      end

      it "queue job to change status when investment ends" do
        sign_in user
        post :validate_step, params: {investment_wizard: valid_attributes, current_step: "review" }
        expect(enqueued_jobs.size).to be >= 1
      end

      it "redirects to pay step of investment create" do
        # TODO add ID of investment
        #post :validate_step, params: { investment_wizard: valid_attributes, current_step: "review"}
        #expect(response).to redirect_to(pay_wizard_investment_path(investment: valid_attributes.id))
      end
    end

  end
end
