require 'rails_helper'

RSpec.describe "open_invites/index", type: :view do
  before(:each) do
    assign(:open_invites, [
      OpenInvite.create!(
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
      ),
      OpenInvite.create!(
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
      )
    ])
  end

  it "renders a list of open_invites" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
