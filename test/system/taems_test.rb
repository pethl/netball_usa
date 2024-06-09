require "application_system_test_case"

class TaemsTest < ApplicationSystemTestCase
  test "Creating a new team" do
    # When we visit the Taems#index page
    # we expect to see a title with the text "Quotes"
    visit taems_path
    assert_selector "h1", text: "Taems"

    # When we click on the link with the text "New team"
    # we expect to land on a page with the title "New team"
    click_on "New taem"
    assert_selector "h1", text: "New taem"

    # When we fill in the name input with "Capybara quote"
    # and we click on "Create Quote"
    fill_in "Name", with: "Capybara quote"
    click_on "Create quote"

    # We expect to be back on the page with the title "Quotes"
    # and to see our "Capybara quote" added to the list
    assert_selector "h1", text: "Quotes"
    assert_text "Capybara quote"
  end
end