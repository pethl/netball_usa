require 'rails_helper'

RSpec.describe "Individual Members User ", type: :feature, js: true do
  let(:user) { create(:user, :teamlead, password: "password123") }

  scenario "Standard user logs in, creates individual membership, and logs out" do
    # Log in as an user
    login_user(user)

   # expect(page).to have_content("Let's Get Started →")

   # click_link "Let's Get Started →"

    expect(page).to have_content("Please select your membership type to get started.")

    click_button "Individual Membership"
    expect(page).to have_title "Create Individual Membership"
   
    select "Individual", from: "individual_member_membership_type"

    fill_in "individual_member_first_name", with: user.first_name
    fill_in "individual_member_last_name", with: user.last_name
    fill_in "individual_member_email", with: user.email

    fill_in "individual_member_phone", with: "0400000000"
    fill_in "individual_member_address", with: "123 Main St"
    fill_in "individual_member_city", with: "Suburbia"
    find("#individual_member_state").find("option[value='FL']").select_option
    fill_in "individual_member_country", with: "USA"
    fill_in "individual_member_zip", with: "1234"

     select "Female", from: "individual_member_gender"
     select "Adult", from: "individual_member_age_status"
     select "Active", from: "individual_member_engagement_status"

   

    click_button "Save Record"

    expect(page).to have_content("Individual member was successfully created.")
    expect(page).to have_title("Individual Member: #{user.first_name} #{user.last_name}")
    expect(page).to have_content("Payment Due for 2025")

    # Log out using the helper
    logout_user

    
  end

  scenario "User fails to create Individual Membership without mandatory fields" do

    login_user(user)

    visit new_individual_member_path

    click_button "Save Record"

    expect(page).to have_content("6 errors prohibited this record from being saved:") # Validation errors should show
   
  end

  scenario "User edits an existing individual membership successfully" do
    # Create the individual member (using your lovely factory)
    individual_member = create(:individual_member, user: user)
  
    login_user(user)
  
    # Visit the correct page (assuming login redirects to landing)
    expect(page).to have_content("Welcome back, #{user.first_name} #{user.last_name}!")
  
    click_button "#{user.first_name} #{user.last_name}"
  
    expect(page).to have_content("Member Details")
    click_link "Edit my details"
  
    expect(page).to have_title("Edit Individual Membership")
  
    fill_in "individual_member_phone", with: "0400000000"
    click_button "Save Record"
  
    expect(page).to have_content("Individual member was successfully updated.")
    expect(individual_member.reload.phone).to eq("0400000000")
  
    logout_user
  end


  scenario "does NOT see renew banner if created this year" do
    individual_member = create(:individual_member, user: user)
    
    login_user(user)
  
    expect(page).to have_content("Welcome back, #{user.first_name} #{user.last_name}!")
  
    expect(page).not_to have_content("Do you wish to renew your annual membership for the new season?")
  end
  
  scenario "does see renew banner if created last year" do
    # Create a member who joined last year
    individual_member = create(
      :individual_member, 
      user: user, 
      created_at: 1.year.ago
    )
    
    login_user(user)
  
    expect(page).to have_text("Ready for another netball season")

  
    expect(page).to have_content("Do you wish to renew your annual membership for the new season?")
    # (make sure this matches exactly what's on your page)
  end
  

end
