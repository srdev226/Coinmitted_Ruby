require 'rails_helper'

RSpec.describe "transactions/index", type: :view do
  before(:each) do
    assign(:transactions, [
      Transaction.create!(),
      Transaction.create!()
    ])
  end

  it "renders a list of transactions" do
    render
  end
end
