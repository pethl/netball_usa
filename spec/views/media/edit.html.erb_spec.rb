require 'rails_helper'

RSpec.describe "media/edit", type: :view do
  let(:medium) {
    Medium.create!(
      company_name: "MyString",
      contact_name: "MyString",
      contact_position: "MyString",
      email: "MyString",
      phone: "MyString",
      city: "MyString",
      state: "MyString",
      country: "MyString",
      pitch: "MyText",
      media_announcement_link: "MyString"
    )
  }

  before(:each) do
    assign(:medium, medium)
  end

  it "renders the edit medium form" do
    render

    assert_select "form[action=?][method=?]", medium_path(medium), "post" do

      assert_select "input[name=?]", "medium[company_name]"

      assert_select "input[name=?]", "medium[contact_name]"

      assert_select "input[name=?]", "medium[contact_position]"

      assert_select "input[name=?]", "medium[email]"

      assert_select "input[name=?]", "medium[phone]"

      assert_select "input[name=?]", "medium[city]"

      assert_select "input[name=?]", "medium[state]"

      assert_select "input[name=?]", "medium[country]"

      assert_select "textarea[name=?]", "medium[pitch]"

      assert_select "input[name=?]", "medium[media_announcement_link]"
    end
  end
end
