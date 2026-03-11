# spec/features/netball_educators_spec.rb
require 'rails_helper'

RSpec.describe "NetballEducators Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin) }

  context "as an admin user" do
    before do
      login_as(admin_user, scope: :user)
    end

    scenario "creates a new Netball Educator successfully" do
      visit new_netball_educator_path

      fill_in "netball_educator_first_name", with: "Brie"
      fill_in "netball_educator_last_name", with: "Doe"
      fill_in "netball_educator_email", with: "brie.doe@example.com"
      fill_in "netball_educator_school_name", with: "Test School"
      fill_in "netball_educator_city", with: "Miami"
      find("#netball_educator_state").find("option[value='FL']").select_option
      find("#netball_educator_level").find("option[value='High']").select_option

      expect(page).to have_button("Save Details")
      click_button "Save Details"

      educator = NetballEducator.find_by(email: "brie.doe@example.com")
      expect(educator).not_to be_nil
      expect(educator.email).to eq("brie.doe@example.com")
    end

    scenario "fails to create a Netball Educator without mandatory fields" do
      visit new_netball_educator_path

      click_button "Save Details"

      expect(page).to have_content("can't be blank")
    end

    scenario "edits an existing Netball Educator successfully" do
      educator = create(:netball_educator)

      visit edit_netball_educator_path(educator)

      fill_in "netball_educator_city", with: "New York"
      click_button "Save Details"

      expect(page).to have_content("Educator was successfully updated.")
      expect(educator.reload.city).to eq("New York")
    end

    scenario "sees equipment section after saving" do
      educator = create(:netball_educator)

      visit edit_netball_educator_path(educator)

      expect(page).to have_content("Equipment Sales")
      expect(page).to have_link("➕ Add New Equipment Sale")
    end
  end

  context "as an anonymous user" do
    before { logout(:user) }

    scenario "can sign up as a Netball Educator" do
      visit "/pages/educator_sign_up"

      fill_in "netball_educator_first_name", with: "Alex"
      fill_in "netball_educator_last_name", with: "Smith"
      fill_in "netball_educator_email", with: "alex.smith@example.com"
      fill_in "netball_educator_phone", with: "555-123-4567"
      fill_in "netball_educator_title", with: "PE Teacher"
      fill_in "netball_educator_school_name", with: "Sunrise Middle School"
      fill_in "netball_educator_address", with: "123 Education Way"
      fill_in "netball_educator_city", with: "Orlando"
      select "Florida", from: "netball_educator_state"
      fill_in "netball_educator_zip", with: "32801"
      fill_in "netball_educator_website", with: "http://sunrisemiddle.edu"
      select "Middle", from: "netball_educator_level"
      fill_in "netball_educator_educator_notes", with: "Looking for program info"
      fill_in "netball_educator_feedback", with: "Great session!"
      check("netball_educator_authorize")

      click_button "Save Details"

      expect(page).to have_current_path(%r{/netball_educators/[a-f0-9\-]+}, wait: 5)
      expect(page).to have_content("Alex Smith")
      expect(page).to have_content("alex.smith@example.com")

      educator = NetballEducator.find_by(email: "alex.smith@example.com")
      expect(educator).not_to be_nil
      expect(educator.first_name).to eq("Alex")
      expect(educator.authorize).to eq(true)
    end

    scenario "cannot see equipment section or prompts" do
      visit "/pages/educator_sign_up"

      expect(page).not_to have_content("Equipment Sales")
      expect(page).not_to have_content("Save the educator first to add equipment sales.")
      expect(page).not_to have_link("➕ Add New Equipment Sale")
    end

    scenario "cannot access index page of Netball Educators" do
      visit netball_educators_path
      expect(current_path).to eq(new_user_session_path)
    end

    scenario "cannot access the edit page of a Netball Educator" do
      educator = create(:netball_educator)
      visit edit_netball_educator_path(educator)
      expect(current_path).to eq(new_user_session_path)
    end

    scenario "can view a public Netball Educator show page" do
      educator = create(:netball_educator, first_name: "Olivia")
      visit netball_educator_path(educator)
      expect(page).to have_content("Olivia")
    end
  end

  shared_examples "can manage educators" do |role|
    let(:user) { create(:user, role: role) }

    before do
      login_as(user, scope: :user)
    end

    scenario "sees Add New button on index page" do
      visit netball_educators_path

      expect(page).to have_selector("#add-new-educator", wait: 5)
    end

    scenario "creates a new Netball Educator" do
      visit new_netball_educator_path

      fill_in "netball_educator_first_name", with: "Casey"
      fill_in "netball_educator_last_name", with: "Taylor"
      fill_in "netball_educator_email", with: "casey.taylor@example.com"
      fill_in "netball_educator_school_name", with: "Sunset High"
      fill_in "netball_educator_city", with: "Austin"
      find("#netball_educator_state").find("option[value='TX']").select_option
      find("#netball_educator_level").find("option[value='Middle']").select_option

      click_button "Save Details"

      expect(page).to have_content("Casey Taylor")
      expect(NetballEducator.exists?(email: "casey.taylor@example.com")).to be true
    end

    scenario "edits an existing Netball Educator" do
      educator = create(:netball_educator, first_name: "Jamie")

      visit edit_netball_educator_path(educator)
      fill_in "netball_educator_city", with: "Houston"
      click_button "Save Details"

      expect(page).to have_content("Educator was successfully updated.")
      expect(educator.reload.city).to eq("Houston")
    end
  end

  context "as an educators_events_medium user" do
    include_examples "can manage educators", "educators_events_medium"
  end

  context "as an educators_events user" do
    include_examples "can manage educators", "educators_events"
  end

end
