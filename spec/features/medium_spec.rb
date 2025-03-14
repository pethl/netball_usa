require 'rails_helper'

RSpec.feature "Mediums", type: :feature do
  let(:user) { create(:user) }  # Assuming you're using Devise or have a user factory
  let(:medium) { create(:medium, user: user) }  # Assuming you have a medium factory

  # Before each test, sign in the user
  before do
    sign_in user  # Assuming you're using Devise or similar for authentication
  end

  # Test for New Medium
  scenario 'User creates a new medium' do
    visit new_medium_path

    expect(page).to have_selector('select#medium_media_type', visible: true)

    select 'Podcasts', from: 'medium[media_type]'
    fill_in 'medium_company_name', with: 'Test Company'
    fill_in 'medium_contact_name', with: 'John Doe'
    fill_in 'medium_email', with: 'john@example.com'
    fill_in 'medium_phone', with: '1234567890'
    fill_in 'medium_city', with: 'New York'
    select 'State', from: 'state'  # Select 'Podcasts' from the dropdown
    fill_in 'Country', with: 'USA'

    click_button 'Create Medium'  # Assuming the button text is 'Create Medium'

    expect(page).to have_content('Medium was successfully created')
    expect(page).to have_content('Test Company')
  end

  # Test for Edit Medium
  scenario 'User edits an existing medium' do
    visit edit_medium_path(medium)

     fill_in 'medium_company_name', with: 'Updated Company Name'
    fill_in 'Email', with: 'updated@example.com'
    click_button 'Update Medium'

    expect(page).to have_content('Medium was successfully updated')
    expect(page).to have_content('Updated Company Name')
  end

  # Test for Show Medium
  scenario 'User views a medium' do
    visit medium_path(medium)

    expect(page).to have_content(medium.company_name)
    expect(page).to have_content(medium.contact_name)
    expect(page).to have_content(medium.email)
    expect(page).to have_content(medium.phone)
  end
end
