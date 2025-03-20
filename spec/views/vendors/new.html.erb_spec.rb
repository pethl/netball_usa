require 'rails_helper'

RSpec.describe "vendors/new", type: :view do
  before(:each) do
    assign(:vendor, Vendor.new(
      company_name: "MyString",
      contact_name: "MyString",
      email: "MyString",
      phone: "MyString",
      notes: "MyText"
    ))
  end

  it "renders new vendor form" do
    render

    assert_select "form[action=?][method=?]", vendors_path, "post" do

      assert_select "input[name=?]", "vendor[company_name]"

      assert_select "input[name=?]", "vendor[contact_name]"

      assert_select "input[name=?]", "vendor[email]"

      assert_select "input[name=?]", "vendor[phone]"

      assert_select "textarea[name=?]", "vendor[notes]"
    end
  end
end
