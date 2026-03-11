require "rails_helper"

RSpec.describe "People", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }

  scenario "Admin creates a person" do
    login_user(admin_user)

    visit new_person_path

    fill_in "person_first_name", with: "Jane"
    fill_in "person_last_name", with: "Smith"
    fill_in "person_email", with: "jane@example.com"

    select "Active", from: "person_status"
    select "Scorer", from: "person_role"
    select "US & Canada", from: "person_region"

    find("input[type='submit']").click

    expect(page).to have_content("Person was successfully created.")
    expect(page).to have_content("Jane")
  end

  scenario "Admin edits a person" do
    login_user(admin_user)

    person = create(:person, role: "Scorer", status: "Active", region: "US & Canada")

    visit edit_person_path(person)

    fill_in "person_first_name", with: "Updated"

    find("input[type='submit']").click

    expect(page).to have_content("Person was successfully updated.")
    expect(person.reload.first_name).to eq("Updated")
  end
end