require 'rails_helper'

RSpec.describe "netball_academies/show", type: :view do
  before(:each) do
    assign(:netball_academy, NetballAcademy.create!(
      first_name: "First Name",
      last_name: "Last Name",
      email: "Email",
      city: "City",
      us_state: "Us State",
      country: "Country",
      club: nil,
      other_club_name: "Other Club Name",
      status: "Status",
      subscribed_plans: "Subscribed Plans",
      amount: "9.99",
      notes: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Us State/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Other Club Name/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Subscribed Plans/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/MyText/)
  end
end
