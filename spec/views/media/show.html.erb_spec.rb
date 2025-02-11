require 'rails_helper'

RSpec.describe "media/show", type: :view do
  before(:each) do
    assign(:medium, Medium.create!(
      company_name: "Company Name",
      contact_name: "Contact Name",
      contact_position: "Contact Position",
      email: "Email",
      phone: "Phone",
      city: "City",
      state: "State",
      country: "Country",
      pitch: "MyText",
      media_announcement_link: "Media Announcement Link"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Company Name/)
    expect(rendered).to match(/Contact Name/)
    expect(rendered).to match(/Contact Position/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Media Announcement Link/)
  end
end
