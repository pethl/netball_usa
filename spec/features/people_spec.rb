require "rails_helper"

RSpec.describe "People", type: :feature, js: true do
  let(:admin_user) do
    User.find(10).tap do |user|
      user.update!(
        admin: true,
        role: :admin,
        password: "password123",
        password_confirmation: "password123"
      )
    end
  end

  scenario "Admin creates a person" do
    login_user(admin_user)

    visit new_person_path

    fill_in "person_first_name", with: "Jane"
    fill_in "person_last_name", with: "Smith"
    fill_in "person_email", with: "jane@example.com"
    fill_in "person_zip_code", with: "90210"

    select "Active", from: "person_status"
    select "Scorer", from: "person_role"
    select "US & Canada", from: "person_region"

    click_button "Save Record"

    expect(page).to have_content("Person was successfully created.")
    expect(page).to have_content("Jane")
    expect(page).to have_content("90210")

    person = Person.find_by!(email: "jane@example.com")

    expect(person.zip_code).to eq("90210")
  end

  scenario "Admin edits a person" do
    login_user(admin_user)

    person = create(
      :person,
      role: "Scorer",
      status: "Active",
      region: "US & Canada",
      zip_code: "10001"
    )

    visit edit_person_path(person)

    fill_in "person_first_name", with: "Updated"
    fill_in "person_zip_code", with: "30301"

    click_button "Save Record"

    expect(page).to have_content("Person was successfully updated.")

    person.reload

    expect(person.first_name).to eq("Updated")
    expect(person.zip_code).to eq("30301")
  end

  scenario "Admin deletes an unlinked person" do
    login_user(admin_user)

    person = create(
      :person,
      role: "Scorer",
      status: "Active",
      region: "US & Canada"
    )

    visit edit_person_path(person)

    accept_confirm do
      click_button "Delete this Person"
    end

    expect(page).to have_current_path(
      people_path(format: :html),
      ignore_query: true
    )

    expect(page).to have_content("Person was successfully deleted.")
    expect(Person.exists?(person.id)).to be(false)
  end

  scenario "Admin cannot delete a person linked to a program" do
    login_user(admin_user)

    person = create(
      :person,
      role: "Scorer",
      status: "Active",
      region: "US & Canada"
    )

    program = create(:program, person: person)

    visit edit_person_path(person)

    accept_confirm do
      click_button "Delete this Person"
    end

    expect(page).to have_content(
      "Cannot delete this person because they are linked to other records."
    )

    expect(Person.exists?(person.id)).to be(true)
    expect(Program.exists?(program.id)).to be(true)
  end
end