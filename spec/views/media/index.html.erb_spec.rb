require 'rails_helper'

RSpec.describe "media/index", type: :view do
  before(:each) do
    assign(:media, [
      Medium.create!(
        company_name: "Company Name",
        contact_name: "Contact Name",
        contact_position: "Contact Position",
        email: "Email",
        phone: "Phone",
        city: "City",
        state: "State",
        country: "Country",
        pitch: "MyText",
        media_announcement_link: "Media Announcement Link"
      ),
      Medium.create!(
        company_name: "Company Name",
        contact_name: "Contact Name",
        contact_position: "Contact Position",
        email: "Email",
        phone: "Phone",
        city: "City",
        state: "State",
        country: "Country",
        pitch: "MyText",
        media_announcement_link: "Media Announcement Link"
      )
    ])
  end

  it "renders a list of media" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Company Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Contact Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Contact Position".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Country".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Media Announcement Link".to_s), count: 2
  end
end
