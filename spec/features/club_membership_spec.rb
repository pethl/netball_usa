require 'rails_helper'

RSpec.describe "Club Membership User ", type: :feature, js: true do
  let(:user) { create(:user, :teamlead, password: "password123") }

  scenario "Standard user logs in, creates club membership, and logs out" do
    # Log in as an user
    login_user(user)

   # expect(page).to have_content("Let's Get Started →")

   # click_link "Let's Get Started →"

    expect(page).to have_content("Please select your membership type to get started.")

    click_button "Club Membership"
    expect(page).to have_content "Club Administrator Actions List:"

    click_link "(1) Create club"
   

    fill_in "club_name", with: "Test Club"
    fill_in "club_city", with: "Suburbia"
    find("#club_us_state").find("option[value='FL']").select_option
    fill_in "club_website", with: "https://www.testclub.com"
    fill_in "club_email", with: "exampleclub@example.com"
    fill_in "club_facebook", with: "https://www.facebook.com/testclub"
    fill_in "club_instagram", with: "https://www.instagram.com/testclub"
    fill_in "club_twitter", with: "https://www.twitter.com/testclub"
     fill_in "club_other_sm", with: "social media words here"

     fill_in "club_estimate_total_number_of_club_members", with: "13"
     fill_in "club_estimate_total_active_members", with: "10"
     fill_in "club_estimate_total_part_time_members", with: "3"

     select "1 Team - 8-13 Active Members", from: "club_membership_category"

    click_button "Save Club"

    expect(page).to have_content("Test Club - Suburbia, FL : (Estimated Active: 10/ Part-Time: 3)")
   
    # Log out using the helper
    logout_user

  end

  scenario "User fails to create Club Membership without mandatory fields" do

    login_user(user)

    expect(page).to have_content("Please select your membership type to get started.")

    click_button "Club Membership"
    expect(page).to have_content "Club Administrator Actions List:"


    click_link "(1) Create club"

    click_button "Save Club"

    expect(page).to have_content("6 errors prohibited this club from being saved:") # Validation errors should show
   
  end

  scenario "User edits existing club membership successfully" do
    # Create the club membership (using  factory)
    club = create(:club, creator: user)
  
    login_user(user)
  
    # Visit the correct page (assuming login redirects to landing)
    expect(page).to have_content("Welcome back, #{club.name}")
  
    click_button "#{club.name}"
  
    expect(page).to have_content "Club Administrator Actions List:"

    click_link "Edit club"
  

    fill_in "club_email", with: "testclub@example.com"
    click_button "Save Club"
  
    expect(page).to have_content("#{club.email}")
   
    logout_user
  end


  scenario "does NOT see renew banner if created this year" do
    club = create(:club, creator: user)
    
    login_user(user)
  
    expect(page).to have_content("Welcome back, #{club.name}")
  
    expect(page).not_to have_content("Are #{club.name} ready for a new season? 🌟")

    logout_user
   end
  
  scenario "does see renew banner if created last year" do
    # Create a member who joined last year
   
    club = create(
      :club, 
      creator: user, 
      created_at: 1.year.ago
    )
    
    login_user(user)
  
    expect(page).to have_text("Are #{club.name} ready for a new season? 🌟")

    expect(page).to have_content("Do you wish to renew your annual membership for the new season?")
    # (make sure this matches exactly what's on your page)
    
    logout_user

  end

  scenario "does see renew banner and can renew" do
    # Create a club who joined last year
   
    club = create(
      :club, 
      creator: user, 
      created_at: 1.year.ago
    )
    
    login_user(user)
  
    expect(page).to have_text("Are #{club.name} ready for a new season? 🌟")

    expect(page).to have_content("Do you wish to renew your annual membership for the new season?")

    # Now click the renew button
    click_button "Yes, Renew!"

    # After clicking, expect some confirmation or redirect
    expect(page).to have_content("🎉 Thanks for saying YES! Welcome to a brand new season with Netball America®!") 

    click_button "#{club.name}"
  
    expect(page).to have_content "Club Administrator Actions List:"
     
    logout_user

  end

  scenario "does see renew banner and does not renew" do
    # Create a club who joined last year
   
    club = create(
      :club, 
      creator: user, 
      created_at: 1.year.ago
    )
    
    login_user(user)
  
    expect(page).to have_text("Are #{club.name} ready for a new season? 🌟")

    expect(page).to have_content("Do you wish to renew your annual membership for the new season?")

    # Now click the renew button
    click_button "No, Not Now"

    # After clicking, expect some confirmation or redirect
    expect(page).to have_content("Thanks for letting us know. Hope to see you back in the future!") 

    expect(page).to have_button("Club Details - Disabled", disabled: true)
     
    logout_user
    
  end
  
end
