require 'rails_helper'

RSpec.describe "programs/show", type: :view do
  before(:each) do
    assign(:program, Program.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Program Stage/)
    expect(rendered).to match(/Program Name/)
    expect(rendered).to match(/Na Program Contact Email/)
    expect(rendered).to match(/Na Program Contact Phone/)
    expect(rendered).to match(/Location Name/)
    expect(rendered).to match(/Location Contact Phone/)
    expect(rendered).to match(/Location Contact Email/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zip/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Timezone/)
    expect(rendered).to match(/Funded By/)
    expect(rendered).to match(/MyText/)
  end
end
