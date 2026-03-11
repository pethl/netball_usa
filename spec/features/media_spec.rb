# spec/features/media_management_spec.rb
require 'rails_helper'

RSpec.describe "Media Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }

  scenario "Admin logs in, creates Media, and logs out" do
    login_user(admin_user)

    visit new_medium_path

    select "Podcasts", from: "medium_media_type"
    fill_in "medium_company_name", with: "The Daily Times"
    fill_in "medium_contact_name", with: "John Doe"
    fill_in "medium_contact_email", with: "johnny@dt.com"
    fill_in "medium_contact_position", with: "Editor"
    fill_in "medium_phone", with: "1234567890"
    fill_in "medium_city", with: "New York"
    find("#medium_state").find("option[value='NY']").select_option
    fill_in "medium_country", with: "USA"
    fill_in "medium_pitch", with: "A great story idea!"
    fill_in "medium_action_taken", with: "Followed up via email"
    fill_in "medium_region_other", with: "North America"
    fill_in "medium_company_website", with: "https://dailynews.com"
    fill_in "medium_facebook", with: "@dailynews"
    fill_in "medium_instagram", with: "@dailynews"
    fill_in "medium_twitter", with: "@dailynews"

    click_button "Save Media"

    expect(page).to have_content("Medium was successfully created.")

    logout_user
  end

  scenario "Admin fails to create Media without mandatory fields" do
    login_user(admin_user)

    visit new_medium_path

    click_button "Save Media"

    expect(page).to have_content("Media type can't be blank")
  end

  scenario "Admin edits an existing Media successfully" do
    login_user(admin_user)

    medium = create(:medium) # 🛠️ correct lowercase variable

    visit edit_medium_path(medium)

    fill_in "medium_pitch", with: "An even better story idea!"
    click_button "Save Media"

    expect(page).to have_content("Medium was successfully updated.")

    # Now reload the record and check the pitch
    expect(medium.reload.pitch).to eq("An even better story idea!")
  end
end
