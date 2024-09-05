require 'rails_helper'

RSpec.describe "tours/new", type: :view do
  before(:each) do
    assign(:tour, Tour.new(
      company: "MyString",
      description: "MyText",
      address: "MyText",
      city: "MyString",
      na_state: "MyString",
      website: "MyString",
      pitch_to_na: "MyText",
      pitch_by_na: "MyText",
      follow_up_action: "MyText",
      tour_agreement: "MyText",
      accept_tour: "MyString",
      first_name_primary: "MyString",
      last_name_primary: "MyString",
      role_primary: "MyString",
      email_primary: "MyString",
      cell_primary: "MyString",
      work_phone_primary: "MyString",
      first_name_secondary: "MyString",
      last_name_secondary: "MyString",
      role_secondary: "MyString",
      email_secondary: "MyString",
      cell_secondary: "MyString",
      work_phone_secondary: "MyString"
    ))
  end

  it "renders new tour form" do
    render

    assert_select "form[action=?][method=?]", tours_path, "post" do

      assert_select "input[name=?]", "tour[company]"

      assert_select "textarea[name=?]", "tour[description]"

      assert_select "textarea[name=?]", "tour[address]"

      assert_select "input[name=?]", "tour[city]"

      assert_select "input[name=?]", "tour[na_state]"

      assert_select "input[name=?]", "tour[website]"

      assert_select "textarea[name=?]", "tour[pitch_to_na]"

      assert_select "textarea[name=?]", "tour[pitch_by_na]"

      assert_select "textarea[name=?]", "tour[follow_up_action]"

      assert_select "textarea[name=?]", "tour[tour_agreement]"

      assert_select "input[name=?]", "tour[accept_tour]"

      assert_select "input[name=?]", "tour[first_name_primary]"

      assert_select "input[name=?]", "tour[last_name_primary]"

      assert_select "input[name=?]", "tour[role_primary]"

      assert_select "input[name=?]", "tour[email_primary]"

      assert_select "input[name=?]", "tour[cell_primary]"

      assert_select "input[name=?]", "tour[work_phone_primary]"

      assert_select "input[name=?]", "tour[first_name_secondary]"

      assert_select "input[name=?]", "tour[last_name_secondary]"

      assert_select "input[name=?]", "tour[role_secondary]"

      assert_select "input[name=?]", "tour[email_secondary]"

      assert_select "input[name=?]", "tour[cell_secondary]"

      assert_select "input[name=?]", "tour[work_phone_secondary]"
    end
  end
end
