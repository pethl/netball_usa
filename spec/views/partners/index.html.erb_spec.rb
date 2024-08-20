require 'rails_helper'

RSpec.describe "partners/index", type: :view do
  before(:each) do
    assign(:partners, [
      Partner.create!(
        company: "Company",
        description: "MyText",
        address: "MyText",
        city: "City",
        state: "State",
        website: "Website",
        pitch_to_na: "MyText",
        pitch_by_na: "MyText",
        follow_up_action: "MyText",
        partnership_agreement: "MyText",
        accept_partnership: "Accept Partnership"
      ),
      Partner.create!(
        company: "Company",
        description: "MyText",
        address: "MyText",
        city: "City",
        state: "State",
        website: "Website",
        pitch_to_na: "MyText",
        pitch_by_na: "MyText",
        follow_up_action: "MyText",
        partnership_agreement: "MyText",
        accept_partnership: "Accept Partnership"
      )
    ])
  end

  it "renders a list of partners" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Company".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("City".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("State".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Website".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Accept Partnership".to_s), count: 2
  end
end
