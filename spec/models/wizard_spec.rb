require "rails_helper"

RSpec.describe Wizard::Investment::Base, type: :model do
  subject { Wizard::Investment::Base.new({name: "My Investment", user_id: FactoryBot.create(:user).id}) }
  #let(:investment) { FactoryBot.create :investment }

  describe "#user" do
    it "return Invesmtment instance" do
      expect(subject.investment).to be_a(Investment)
    end
  end

  describe "delegate investment attributes" do
    it "delegates the investment attributes to the invesmtent instance" do
      subject.name = "Foo"
      subject.invested_amount = 100_00
      expect(subject.investment.name).to eq("Foo")
      expect(subject.investment.invested_amount).to eq(10000)
    end
  end

end

RSpec.describe Wizard::Investment::Plan, type: :model do
  subject { Wizard::Investment::Plan.new({investment_plan_id: FactoryBot.create(:investment_plan)}) }

  it { is_expected.to validate_presence_of(:investment_plan_id) }
end

RSpec.describe Wizard::Investment::Name, type: :model do
  subject { Wizard::Investment::Name.new({name: "my investment"}) }
  it { is_expected.to validate_presence_of(:name) }
end

RSpec.describe Wizard::Investment::Timeframe, type: :model do
  subject { Wizard::Investment::Timeframe.new({
    timeframe: 1,
    open_date: Date.today,
    end_date: Date.today
  }) }
  it { is_expected.not_to be nil }
  it { expect(subject.investment.open_date).not_to be nil }
  it { expect(subject.investment.end_date).not_to be nil }
  it { expect(subject.investment.end_date.to_date).to be_a(Date) }
  it { expect(subject.investment.open_date.to_date).to be_a(Date) }
end

RSpec.describe Wizard::Investment::Payout, type: :model do
  subject { Wizard::Investment::Payout.new({
    payout_frequency_id: FactoryBot.create(:payout_frequency)
  }) }
  it { is_expected.to validate_presence_of(:payout_frequency_id) }
end

RSpec.describe Wizard::Investment::Amount, type: :model do

  context "simple validation" do
    subject { Wizard::Investment::Amount.new({invested_amount: 1000, investment_plan_id: FactoryBot.create(:investment_plan).id }) }
    it { is_expected.to validate_presence_of(:invested_amount) }
  end


  context "validate invested amount in range of plan" do
    subject { Wizard::Investment::Amount.new({
      invested_amount: 1000,
      investment_plan_id: FactoryBot.create(:investment_plan,
                                               title: 'basic',
                                           ).id,
      name: "test investment",
      open_date: Date.parse("2018-07-10"),
      end_date: Date.parse("2018-08-10"),
      payout_frequency_id: FactoryBot.create(:payout_frequency).id,
      timeframe: 1,
      user_id: FactoryBot.create(:user).id
      })
    }
    #
    # Failing to test greater to 0 and less to 1000
    # https://github.com/thoughtbot/shoulda-matchers/issues/874
    #
    #it { is_expected.to validate_numericality_of(:invested_amount).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(1000).only_integer }
    it "amount should be not more than plan" do
      expect(subject.invested_amount).to be <= Wizard::Investment::AMOUNT_PLAN[subject.investment.investment_plan.title.downcase.to_sym]
    end
    it "Amount should be beteen min and max" do
      subject.invested_amount = 50
      expect(subject.invested_amount).to be_between(subject.amount_plan_min, subject.amount_plan_max).inclusive
    end
  end
end

RSpec.describe Wizard::Investment::Payment, type: :model do
  subject { Wizard::Investment::Payment.new({
    payment_method_id: FactoryBot.create(:payment_method),
    investment_plan_id: FactoryBot.create(:investment_plan).id
  }) }
  it { is_expected.to validate_presence_of(:payment_method_id) }
end
