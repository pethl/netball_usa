require 'rails_helper'

RSpec.describe "clubs/show", type: :view do
  before(:each) do
    assign(:club, Club.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Us State/)
    expect(rendered).to match(/Membership Category/)
    expect(rendered).to match(/Website/)
    expect(rendered).to match(/Facebook/)
    expect(rendered).to match(/Twitter/)
    expect(rendered).to match(/Instagram/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
