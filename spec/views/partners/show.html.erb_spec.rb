require 'rails_helper'

RSpec.describe "partners/show", type: :view do
  before(:each) do
    assign(:partner, Partner.create!(
      company: "Company",
      description: "MyText",
      address: "MyText",
      city: "City",
      state: "State",
      website: "Website",
      pitch_to_na: "MyText",
      pitch_by_na: "MyText",
      follow_up_action: "MyText",
      partnership_agreement: "MyText",
      accept_partnership: "Accept Partnership"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Accept Partnership/)
  end
end
