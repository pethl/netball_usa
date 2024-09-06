require 'rails_helper'

RSpec.describe "clubs/index", type: :view do
  before(:each) do
    assign(:clubs, [
      Club.create!(
        name: "Name",
        city: "City",
        us_state: "Us State",
        membership_category: "Membership Category",
        website: "Website",
        facebook: "Facebook",
        twitter: "Twitter",
        instagram: "Instagram",
        other_sm: "MyText",
        estimate_total_number_of_club_members: 2,
        estimate_total_active_members: 3,
        estimate_total_part_time_members: 4
      ),
      Club.create!(
        name: "Name",
        city: "City",
        us_state: "Us State",
        membership_category: "Membership Category",
        website: "Website",
        facebook: "Facebook",
        twitter: "Twitter",
        instagram: "Instagram",
        other_sm: "MyText",
        estimate_total_number_of_club_members: 2,
        estimate_total_active_members: 3,
        estimate_total_part_time_members: 4
      )
    ])
  end

  it "renders a list of clubs" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Us State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Membership Category".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Website".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Facebook".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Twitter".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Instagram".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
  end
end
