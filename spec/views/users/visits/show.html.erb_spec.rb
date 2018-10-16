require "rails_helper"

RSpec.describe "users/visits/show", type: :view do
  let(:user) { create(:user, role: 'admin') }
  before :each do
    @visits = assign(:visits, Ahoy::Visit.create(user_id: user.id))
  end

  it "renders attributes in <p>" do
    sign_in user
    render
  end
end
