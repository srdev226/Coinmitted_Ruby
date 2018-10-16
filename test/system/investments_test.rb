require "application_system_test_case"

class InvestmentsTest < ApplicationSystemTestCase
  setup do
    @investment = investments(:one)
  end

  test "visiting the index" do
    visit investments_url
    assert_selector "h1", text: "Investments"
  end

  test "creating a Investment" do
    visit investments_url
    click_on "New Investment"

    fill_in "End Date", with: @investment.end_date
    fill_in "Invested Amount", with: @investment.invested_amount
    fill_in "Name", with: @investment.name
    fill_in "Open Date", with: @investment.open_date
    fill_in "Status", with: @investment.status
    click_on "Create Investment"

    assert_text "Investment was successfully created"
    click_on "Back"
  end

  test "updating a Investment" do
    visit investments_url
    click_on "Edit", match: :first

    fill_in "End Date", with: @investment.end_date
    fill_in "Invested Amount", with: @investment.invested_amount
    fill_in "Name", with: @investment.name
    fill_in "Open Date", with: @investment.open_date
    fill_in "Status", with: @investment.status
    click_on "Update Investment"

    assert_text "Investment was successfully updated"
    click_on "Back"
  end

  test "destroying a Investment" do
    visit investments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Investment was successfully destroyed"
  end
end
