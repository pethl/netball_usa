require 'rails_helper'

RSpec.describe "Payments Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin, password: "password123") }
  let!(:club) { create(:club) }  # Payment needs to link to a club

  scenario "Admin logs in, creates a Payment linked to a Club, and logs out" do
    login_user(admin_user)

    visit new_payment_path

    select "Zelle", from: "payment_payment_type"   # adjust if needed
    fill_in "payment_amount", with: "90.00"
    fill_in "payment_payment_year", with: Date.today.year
    fill_in "payment_payment_received_date", with: Date.today.strftime("%Y-%m-%d")
    fill_in "payment_payment_transaction_reference", with: "PAY123ABC"
    fill_in "payment_payment_notes", with: "Paid in full"

    # Select the Club
    select club.name, from: "payment_club_id"  # make sure your form has a select box for club_id

    click_button "Save Payment"

    expect(page).to have_content("Payment was successfully created.")

    logout_user
  end

  scenario "Admin fails to create Payment without mandatory fields" do
    login_user(admin_user)

    visit new_payment_path

    click_button "Save Payment"

   # expect(page).to have_content("Payment year can't be blank") not required as defaulted
    expect(page).to have_content("Payment type can't be blank")
    expect(page).to have_content("Must link to either an individual member or a club") # your custom validation!
  end

  scenario "Admin edits an existing Payment successfully" do
    login_user(admin_user)

    payment = create(:payment, :club_payment)  # create a payment linked to a club

    visit edit_payment_path(payment)

    fill_in "payment_payment_notes", with: "Updated payment notes"
    click_button "Save Payment"

    expect(page).to have_content("Payment was successfully updated.")

    expect(payment.reload.payment_notes).to eq("Updated payment notes")
  end
end
