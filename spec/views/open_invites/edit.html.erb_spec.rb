require 'rails_helper'

RSpec.describe "open_invites/edit", type: :view do
  let(:open_invite) {
    OpenInvite.create!(
      status: "MyString",
      invite_sent: false,
      rspv: false,
      whova: false,
      flight_booked: false,
      sent_save_the_date: false,
      response_to_save_the_date: false,
      send_official_invite: false,
      comments: "MyText",
      people: nil
    )
  }

  before(:each) do
    assign(:open_invite, open_invite)
  end

  it "renders the edit open_invite form" do
    render

    assert_select "form[action=?][method=?]", open_invite_path(open_invite), "post" do

      assert_select "input[name=?]", "open_invite[status]"

      assert_select "input[name=?]", "open_invite[invite_sent]"

      assert_select "input[name=?]", "open_invite[rspv]"

      assert_select "input[name=?]", "open_invite[whova]"

      assert_select "input[name=?]", "open_invite[flight_booked]"

      assert_select "input[name=?]", "open_invite[sent_save_the_date]"

      assert_select "input[name=?]", "open_invite[response_to_save_the_date]"

      assert_select "input[name=?]", "open_invite[send_official_invite]"

      assert_select "textarea[name=?]", "open_invite[comments]"

      assert_select "input[name=?]", "open_invite[people_id]"
    end
  end
end
