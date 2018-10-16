require 'rails_helper'

RSpec.describe "investments/index.html.erb", type: :view do

  let(:user) { create(:user) }

  it "has link to payouts" do
    assign(:cur_sign, "USD")
    assign(:investments, [
      create(:investment, user_id: user.id),
      create(:investment, user_id: user.id),
      ]
    )
    sign_in user
    render
    expect(rendered).to include 'Show'
    expect(rendered).to include 'Edit'

  end

end
