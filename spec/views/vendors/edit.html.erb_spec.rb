require 'rails_helper'

RSpec.describe "vendors/edit", type: :view do
  let(:vendor) {
    Vendor.create!(
      company_name: "MyString",
      contact_name: "MyString",
      email: "MyString",
      phone: "MyString",
      notes: "MyText"
    )
  }

  before(:each) do
    assign(:vendor, vendor)
  end

  it "renders the edit vendor form" do
    render

    assert_select "form[action=?][method=?]", vendor_path(vendor), "post" do

      assert_select "input[name=?]", "vendor[company_name]"

      assert_select "input[name=?]", "vendor[contact_name]"

      assert_select "input[name=?]", "vendor[email]"

      assert_select "input[name=?]", "vendor[phone]"

      assert_select "textarea[name=?]", "vendor[notes]"
    end
  end
end
