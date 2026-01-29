require "rails_helper"

RSpec.describe "Grant Management", type: :feature, js: true do
  let(:grant_user) { create(:user, :grant_user) }  # role: grants (3)
  let(:admin_user) { create(:user, :admin) }       # role: admin (0)

  scenario "Grant user creates a grant" do
    login_user(grant_user)

    visit new_grant_path
    expect(page).to have_field("grant_name")

    fill_in "grant_name", with: "Community Sports Grant"
    select "In Progress", from: "grant_status"

    click_button "Save Record"

    expect(page).to have_content("Grant was successfully created")
  end

  scenario "Grant user fails validation" do
    login_user(grant_user)

    visit new_grant_path
    click_button "Save Record"

    expect(page).to have_content("Name can't be blank")
   
  end

  scenario "Admin updates restricted fields" do
    grant = create(:grant, user: grant_user)

    login_user(admin_user)

    visit edit_grant_path(grant)
    expect(page).to have_field("grant_program")

    fill_in "grant_program", with: "BAI Southern California"
    click_button "Save Record"

    expect(grant.reload.program).to eq("BAI Southern California")
  end

  scenario "Admin deletes a grant" do
    grant = create(:grant)

    login_user(admin_user)

    visit grant_path(grant)
    expect(page).to have_button("Delete this record")

    accept_confirm do
      click_button "Delete this record"
    end

    expect(Grant.exists?(grant.id)).to be false
  end
end
