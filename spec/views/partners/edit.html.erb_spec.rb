require 'rails_helper'

RSpec.describe "partners/edit", type: :view do
  let(:partner) {
    Partner.create!(
      company: "MyString",
      description: "MyText",
      address: "MyText",
      city: "MyString",
      state: "MyString",
      website: "MyString",
      pitch_to_na: "MyText",
      pitch_by_na: "MyText",
      follow_up_action: "MyText",
      partnership_agreement: "MyText",
      accept_partnership: "MyString"
    )
  }

  before(:each) do
    assign(:partner, partner)
  end

  it "renders the edit partner form" do
    render

    assert_select "form[action=?][method=?]", partner_path(partner), "post" do

      assert_select "input[name=?]", "partner[company]"

      assert_select "textarea[name=?]", "partner[description]"

      assert_select "textarea[name=?]", "partner[address]"

      assert_select "input[name=?]", "partner[city]"

      assert_select "input[name=?]", "partner[state]"

      assert_select "input[name=?]", "partner[website]"

      assert_select "textarea[name=?]", "partner[pitch_to_na]"

      assert_select "textarea[name=?]", "partner[pitch_by_na]"

      assert_select "textarea[name=?]", "partner[follow_up_action]"

      assert_select "textarea[name=?]", "partner[partnership_agreement]"

      assert_select "input[name=?]", "partner[accept_partnership]"
    end
  end
end
