require 'rails_helper'

RSpec.describe "open_invites/new", type: :view do
  before(:each) do
    assign(:open_invite, OpenInvite.new(
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
    ))
  end

  it "renders new open_invite form" do
    render

    assert_select "form[action=?][method=?]", open_invites_path, "post" do

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
