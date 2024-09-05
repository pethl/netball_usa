require 'rails_helper'

RSpec.describe "tours/index", type: :view do
  before(:each) do
    assign(:tours, [
      Tour.create!(
        company: "Company",
        description: "MyText",
        address: "MyText",
        city: "City",
        na_state: "Na State",
        website: "Website",
        pitch_to_na: "MyText",
        pitch_by_na: "MyText",
        follow_up_action: "MyText",
        tour_agreement: "MyText",
        accept_tour: "Accept Tour",
        first_name_primary: "First Name Primary",
        last_name_primary: "Last Name Primary",
        role_primary: "Role Primary",
        email_primary: "Email Primary",
        cell_primary: "Cell Primary",
        work_phone_primary: "Work Phone Primary",
        first_name_secondary: "First Name Secondary",
        last_name_secondary: "Last Name Secondary",
        role_secondary: "Role Secondary",
        email_secondary: "Email Secondary",
        cell_secondary: "Cell Secondary",
        work_phone_secondary: "Work Phone Secondary"
      ),
      Tour.create!(
        company: "Company",
        description: "MyText",
        address: "MyText",
        city: "City",
        na_state: "Na State",
        website: "Website",
        pitch_to_na: "MyText",
        pitch_by_na: "MyText",
        follow_up_action: "MyText",
        tour_agreement: "MyText",
        accept_tour: "Accept Tour",
        first_name_primary: "First Name Primary",
        last_name_primary: "Last Name Primary",
        role_primary: "Role Primary",
        email_primary: "Email Primary",
        cell_primary: "Cell Primary",
        work_phone_primary: "Work Phone Primary",
        first_name_secondary: "First Name Secondary",
        last_name_secondary: "Last Name Secondary",
        role_secondary: "Role Secondary",
        email_secondary: "Email Secondary",
        cell_secondary: "Cell Secondary",
        work_phone_secondary: "Work Phone Secondary"
      )
    ])
  end

  it "renders a list of tours" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Company".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Na State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Website".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Accept Tour".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("First Name Primary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name Primary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Role Primary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email Primary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cell Primary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Work Phone Primary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("First Name Secondary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Last Name Secondary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Role Secondary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email Secondary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cell Secondary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Work Phone Secondary".to_s), count: 2
  end
end
