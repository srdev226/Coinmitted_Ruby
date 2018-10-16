require 'rails_helper'

RSpec.describe WeekPercentage, type: :model do

  let(:wp) { FactoryBot.create(:week_percentage) }


  describe "Validations" do
    it { is_expected.to validate_presence_of(:percentage) }
    it { is_expected.not_to allow_value("abc").for(:percentage) }
    it { is_expected.to allow_value("10").for(:percentage) }
    it { is_expected.to allow_value("10.0").for(:percentage) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_uniqueness_of(:first_date) }
    it { is_expected.to validate_uniqueness_of(:last_date) }
  end
end
