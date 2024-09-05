require 'rails_helper'

RSpec.describe "tours/show", type: :view do
  before(:each) do
    assign(:tour, Tour.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Na State/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Accept Tour/)
    expect(rendered).to match(/First Name Primary/)
    expect(rendered).to match(/Last Name Primary/)
    expect(rendered).to match(/Role Primary/)
    expect(rendered).to match(/Email Primary/)
    expect(rendered).to match(/Cell Primary/)
    expect(rendered).to match(/Work Phone Primary/)
    expect(rendered).to match(/First Name Secondary/)
    expect(rendered).to match(/Last Name Secondary/)
    expect(rendered).to match(/Role Secondary/)
    expect(rendered).to match(/Email Secondary/)
    expect(rendered).to match(/Cell Secondary/)
    expect(rendered).to match(/Work Phone Secondary/)
  end
end
