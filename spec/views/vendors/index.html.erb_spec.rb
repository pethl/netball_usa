require 'rails_helper'

RSpec.describe "vendors/index", type: :view do
  before(:each) do
    assign(:vendors, [
      Vendor.create!(
        company_name: "Company Name",
        contact_name: "Contact Name",
        email: "Email",
        phone: "Phone",
        notes: "MyText"
      ),
      Vendor.create!(
        company_name: "Company Name",
        contact_name: "Contact Name",
        email: "Email",
        phone: "Phone",
        notes: "MyText"
      )
    ])
  end

  it "renders a list of vendors" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Company Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Contact Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
