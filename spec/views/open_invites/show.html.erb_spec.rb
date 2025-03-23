require 'rails_helper'

RSpec.describe "open_invites/show", type: :view do
  before(:each) do
    assign(:open_invite, OpenInvite.create!(
      status: "Status",
      invite_sent: false,
      rspv: false,
      whova: false,
      flight_booked: false,
      sent_save_the_date: false,
      response_to_save_the_date: false,
      send_official_invite: false,
      comments: "MyText",
      people: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
