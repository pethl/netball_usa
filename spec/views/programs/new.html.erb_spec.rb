require 'rails_helper'

RSpec.describe "programs/new", type: :view do
  before(:each) do
    assign(:program, Program.new(
      program_stage: "MyString",
      program_name: "MyString",
      na_program_contact_email: "MyString",
      na_program_contact_phone: "MyString",
      location_name: "MyString",
      location_contact_phone: "MyString",
      location_contact_email: "MyString",
      address: "MyString",
      city: "MyString",
      state: "MyString",
      zip: "MyString",
      country: "MyString",
      people: nil,
      timezone: "MyString",
      funded_by: "MyString",
      notes: "MyText"
    ))
  end

  it "renders new program form" do
    render

    assert_select "form[action=?][method=?]", programs_path, "post" do

      assert_select "input[name=?]", "program[program_stage]"

      assert_select "input[name=?]", "program[program_name]"

      assert_select "input[name=?]", "program[na_program_contact_email]"

      assert_select "input[name=?]", "program[na_program_contact_phone]"

      assert_select "input[name=?]", "program[location_name]"

      assert_select "input[name=?]", "program[location_contact_phone]"

      assert_select "input[name=?]", "program[location_contact_email]"

      assert_select "input[name=?]", "program[address]"

      assert_select "input[name=?]", "program[city]"

      assert_select "input[name=?]", "program[state]"

      assert_select "input[name=?]", "program[zip]"

      assert_select "input[name=?]", "program[country]"

      assert_select "input[name=?]", "program[people_id]"

      assert_select "input[name=?]", "program[timezone]"

      assert_select "input[name=?]", "program[funded_by]"

      assert_select "textarea[name=?]", "program[notes]"
    end
  end
end
