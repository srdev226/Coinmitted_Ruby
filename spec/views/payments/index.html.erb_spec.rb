require 'rails_helper'

RSpec.describe "payments/index", type: :view do

  before(:each) do
    investment = FactoryBot.create(:investment)
    assign(:payments, [
      investment.payments.create!(),
      investment.payments.create!()
    ])
  end

  it "renders a list of payments" do
    render
  end
end
