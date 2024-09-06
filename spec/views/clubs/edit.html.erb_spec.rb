require 'rails_helper'

RSpec.describe "clubs/edit", type: :view do
  let(:club) {
    Club.create!(
      name: "MyString",
      city: "MyString",
      us_state: "MyString",
      membership_category: "MyString",
      website: "MyString",
      facebook: "MyString",
      twitter: "MyString",
      instagram: "MyString",
      other_sm: "MyText",
      estimate_total_number_of_club_members: 1,
      estimate_total_active_members: 1,
      estimate_total_part_time_members: 1
    )
  }

  before(:each) do
    assign(:club, club)
  end

  it "renders the edit club form" do
    render

    assert_select "form[action=?][method=?]", club_path(club), "post" do

      assert_select "input[name=?]", "club[name]"

      assert_select "input[name=?]", "club[city]"

      assert_select "input[name=?]", "club[us_state]"

      assert_select "input[name=?]", "club[membership_category]"

      assert_select "input[name=?]", "club[website]"

      assert_select "input[name=?]", "club[facebook]"

      assert_select "input[name=?]", "club[twitter]"

      assert_select "input[name=?]", "club[instagram]"

      assert_select "textarea[name=?]", "club[other_sm]"

      assert_select "input[name=?]", "club[estimate_total_number_of_club_members]"

      assert_select "input[name=?]", "club[estimate_total_active_members]"

      assert_select "input[name=?]", "club[estimate_total_part_time_members]"
    end
  end
end
