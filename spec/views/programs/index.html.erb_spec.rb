require 'rails_helper'

RSpec.describe "programs/index", type: :view do
  before(:each) do
    assign(:programs, [
      Program.create!(
        program_stage: "Program Stage",
        program_name: "Program Name",
        na_program_contact_email: "Na Program Contact Email",
        na_program_contact_phone: "Na Program Contact Phone",
        location_name: "Location Name",
        location_contact_phone: "Location Contact Phone",
        location_contact_email: "Location Contact Email",
        address: "Address",
        city: "City",
        state: "State",
        zip: "Zip",
        country: "Country",
        people: nil,
        timezone: "Timezone",
        funded_by: "Funded By",
        notes: "MyText"
      ),
      Program.create!(
        program_stage: "Program Stage",
        program_name: "Program Name",
        na_program_contact_email: "Na Program Contact Email",
        na_program_contact_phone: "Na Program Contact Phone",
        location_name: "Location Name",
        location_contact_phone: "Location Contact Phone",
        location_contact_email: "Location Contact Email",
        address: "Address",
        city: "City",
        state: "State",
        zip: "Zip",
        country: "Country",
        people: nil,
        timezone: "Timezone",
        funded_by: "Funded By",
        notes: "MyText"
      )
    ])
  end

  it "renders a list of programs" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Program Stage".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Program Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Na Program Contact Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Na Program Contact Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location Contact Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location Contact Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Address".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Zip".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Country".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Timezone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Funded By".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
