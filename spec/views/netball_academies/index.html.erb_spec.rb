require 'rails_helper'

RSpec.describe "netball_academies/index", type: :view do
  before(:each) do
    assign(:netball_academies, [
      NetballAcademy.create!(
        first_name: "First Name",
        last_name: "Last Name",
        email: "Email",
        city: "City",
        us_state: "Us State",
        country: "Country",
        club: nil,
        other_club_name: "Other Club Name",
        status: "Status",
        subscribed_plans: "Subscribed Plans",
        amount: "9.99",
        notes: "MyText"
      ),
      NetballAcademy.create!(
        first_name: "First Name",
        last_name: "Last Name",
        email: "Email",
        city: "City",
        us_state: "Us State",
        country: "Country",
        club: nil,
        other_club_name: "Other Club Name",
        status: "Status",
        subscribed_plans: "Subscribed Plans",
        amount: "9.99",
        notes: "MyText"
      )
    ])
  end

  it "renders a list of netball_academies" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("First Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Us State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Country".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Other Club Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Subscribed Plans".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
