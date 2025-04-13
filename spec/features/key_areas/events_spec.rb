require 'rails_helper'

RSpec.describe "Event Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }

  scenario "Admin logs in, creates an event, and logs out" do
    # Log in as an admin
    login_user(admin_user)

    visit new_event_path

    
    select "State Conference", from: "event_event_type"
    select "Yes", from: "event_is_educational"
    fill_in "event_name", with: "New Netball Event"
    select "Prep", from: "event_status"
    fill_in "event_date", with: "2025-04-07" # Make sure this is in the correct format
    fill_in "event_end_date", with: "2025-04-08" # Make sure this is in the correct format
    select "TaggTime", from: "event_attend" # Adding attendance option
    fill_in "event_city", with: "New York"
    find("#event_state").find("option[value='NY']").select_option
    fill_in "event_location", with: "Stadium A"
    fill_in "event_details", with: "A training event for coaches."
    fill_in "event_booth", with: "B1"
    fill_in "event_cost_notes", with: "Free"
   
    fill_in "event_outcome", with: "Success"
   
    click_button "Save Event"

    expect(page).to have_content("Event was successfully created.")

    # Log out using the helper
    logout_user

    expect(page).to have_content("You've been logged out")
    expect(page).to have_link("Sign in again")
  end

  scenario "Admin fails to create an event without mandatory fields" do
    login_user(admin_user)

    visit new_event_path

    click_button "Save Event"

    expect(page).to have_content("Event type can't be blank") # Ensure the event name is required
    expect(page).to have_content("Name can't be blank") # Validate other required fields
  end

  scenario "Admin edits an existing event successfully" do
    login_user(admin_user)
    event = create(:event)

    visit edit_event_path(event)

    fill_in "event_name", with: "Updated Netball Event"
    click_button "Save Event"

    expect(page).to have_content("Event was successfully updated.")
    expect(event.reload.name).to eq("Updated Netball Event")
  end
end
