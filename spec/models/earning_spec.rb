require 'rails_helper'

RSpec.describe Earning, type: :model do

  describe "Validations" do
    let(:earning) { FactoryBot.create(:earning) }

    it { expect(earning).not_to be nil }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:investment_id) }
  end
end
