require "rails_helper"

RSpec.feature "NA People self-service journey", type: :feature, js: true do
  scenario "an invited user signs up and accesses their explicitly linked profile and current US Open Transfer" do
    current_us_open = create(
      :event,
      event_type: "US Open",
      name: "Current U.S. Open journey spec",
      date: Date.current.end_of_year
    )
    person = create(
      :person,
      first_name: "Invited",
      last_name: "Person",
      email: "different.profile@example.com",
      status: "Active"
    )
    transfer = create(
      :transfer,
      person: person,
      event: current_us_open
    )

    sign_up_user(
      email: "invited.login@example.com",
      password: "password123",
      role: 12
    )

    user = User.find_by!(email: "invited.login@example.com")
    expect(user.role).to eq("na_people")
    expect(page).to have_content("Sorry, we couldn’t find your profile")

    person.update!(user: user)
    visit root_path

    expect(page).to have_content("Welcome, Invited Person!")
    expect(page).to have_link("View/Edit your profile page")
    expect(page).to have_link(
      "Edit U.S. Open Netball Championships® Information"
    )

    click_link "View/Edit your profile page"
    expect(page).to have_current_path(
      edit_person_path(person),
      ignore_query: true
    )
    expect(page).to have_content("Edit: Invited Person")
    expect(page).not_to have_link("Back to People")

    visit root_path
    click_link "Edit U.S. Open Netball Championships® Information"
    expect(page).to have_current_path(
      edit_transfer_path(transfer),
      ignore_query: true
    )
    expect(page).to have_content(
      "U.S. Open Netball Championships® Volunteer Information"
    )
    expect(page).not_to have_link("Event Attendees")
  end

  scenario "an invited user with no matching profile is offered profile creation" do
    create(
      :event,
      event_type: "US Open",
      name: "Current U.S. Open no-profile spec",
      date: Date.current.end_of_year
    )

    sign_up_user(
      email: "missing.profile@example.com",
      password: "password123",
      role: 12
    )

    expect(User.find_by!(email: "missing.profile@example.com").role).to eq(
      "na_people"
    )
    expect(page).to have_content("Sorry, we couldn’t find your profile")
    expect(page).to have_link("Create your profile")
    expect(page).not_to have_link(
      "Edit U.S. Open Netball Championships® Information"
    )

    click_link "Create your profile"
    expect(page).to have_current_path(new_person_path, ignore_query: true)
  end

  scenario "an invited user with a matching profile but no current Transfer is given the contact action" do
    create(
      :event,
      event_type: "US Open",
      name: "Current U.S. Open no-transfer spec",
      date: Date.current.end_of_year
    )
    person = create(
      :person,
      first_name: "Profile",
      last_name: "Only",
      email: "profile.only@example.com",
      status: "Active"
    )

    sign_up_user(
      email: person.email,
      password: "password123",
      role: 12
    )

    expect(page).to have_content("Welcome, Profile Only!")
    expect(page).to have_link("View/Edit your profile page")
    expect(page).to have_content(
      "You are not currently registered for Current U.S. Open no-transfer spec."
    )
    expect(page).to have_link(
      "info@netballamerica.com",
      href: "mailto:info@netballamerica.com"
    )
    expect(page).not_to have_link(
      "Edit U.S. Open Netball Championships® Information"
    )
  end
end
