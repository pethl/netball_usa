require 'rails_helper'

RSpec.describe "vendors/show", type: :view do
  before(:each) do
    assign(:vendor, Vendor.create!(
      company_name: "Company Name",
      contact_name: "Contact Name",
      email: "Email",
      phone: "Phone",
      notes: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Company Name/)
    expect(rendered).to match(/Contact Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/MyText/)
  end
end
