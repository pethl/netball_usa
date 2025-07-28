require 'rails_helper'

RSpec.describe "netball_academies/new", type: :view do
  before(:each) do
    assign(:netball_academy, NetballAcademy.new(
      first_name: "MyString",
      last_name: "MyString",
      email: "MyString",
      city: "MyString",
      us_state: "MyString",
      country: "MyString",
      club: nil,
      other_club_name: "MyString",
      status: "MyString",
      subscribed_plans: "MyString",
      amount: "9.99",
      notes: "MyText"
    ))
  end

  it "renders new netball_academy form" do
    render

    assert_select "form[action=?][method=?]", netball_academies_path, "post" do

      assert_select "input[name=?]", "netball_academy[first_name]"

      assert_select "input[name=?]", "netball_academy[last_name]"

      assert_select "input[name=?]", "netball_academy[email]"

      assert_select "input[name=?]", "netball_academy[city]"

      assert_select "input[name=?]", "netball_academy[us_state]"

      assert_select "input[name=?]", "netball_academy[country]"

      assert_select "input[name=?]", "netball_academy[club_id]"

      assert_select "input[name=?]", "netball_academy[other_club_name]"

      assert_select "input[name=?]", "netball_academy[status]"

      assert_select "input[name=?]", "netball_academy[subscribed_plans]"

      assert_select "input[name=?]", "netball_academy[amount]"

      assert_select "textarea[name=?]", "netball_academy[notes]"
    end
  end
end
